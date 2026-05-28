extends Node

var supabase_url: String = ""
var supabase_key: String = ""

var sync_timer: Timer = null
var pending_slot: int = 0
var pending_data: Dictionary = {}

func _ready():
	load_config()

func load_config():
	var config = ConfigFile.new()
	if config.load("res://config.cfg") != Error.OK:
		return
	supabase_url = config.get_value("supabase", "url", "")
	supabase_key = config.get_value("supabase", "key", "")

func is_configured() -> bool:
	return supabase_url != "" and supabase_key != ""

func sync_save(slot: int, save_data: Dictionary) -> void:
	if not is_configured():
		return
	
	pending_slot = slot
	pending_data = save_data
	
	if sync_timer and is_instance_valid(sync_timer):
		sync_timer.stop()
		sync_timer.queue_free()
	
	sync_timer = Timer.new()
	sync_timer.wait_time = 3.0
	sync_timer.one_shot = true
	sync_timer.timeout.connect(_do_sync)
	add_child(sync_timer)
	sync_timer.start()

func _do_sync():
	_upload_save(pending_slot, pending_data)
	sync_timer = null

func restore_saves_from_id(target_id: String, callback: Callable) -> void:
	if not is_configured():
		callback.call(false, "Sem conexão com o servidor")
		return
	
	var http = HTTPRequest.new()
	add_child(http)
	
	var headers = _get_headers()
	http.request_completed.connect(_on_restore_fetched.bind(http, target_id, callback))
	
	var url = supabase_url + "/rest/v1/saves?player_id=eq." + target_id
	if http.request(url, headers, HTTPClient.METHOD_GET) != OK:
		callback.call(false, "Erro ao conectar")
		http.queue_free()

func _on_restore_fetched(result, response_code, headers, body, http, target_id: String, callback: Callable):
	http.queue_free()
	
	if response_code != 200:
		callback.call(false, "Erro ao buscar saves (código %d)" % response_code)
		return
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var saves = json.data
	
	if saves == null or saves.size() == 0:
		callback.call(false, "Nenhum save encontrado para esse ID")
		return
	
	PlayerIdManager.override_id(target_id)
	
	for save in saves:
		var slot = save.get("slot", 1)
		var path = "res://saves/save%d.save" % slot
		
		var save_data = {
			"player_name": save.get("player_name", ""),
			"experience": save.get("experience", 0),
			"memory": save.get("memory", 0),
			"agility": save.get("agility", 0),
			"focus": save.get("focus", 0),
			"reasoning": save.get("reasoning", 0),
			"coordination": save.get("coordination", 0),
			"player_health": save.get("player_health", 0),
			"player_time": save.get("player_time", 0),
			"player_damage": save.get("player_damage", 0),
			"player_crit_chance": save.get("player_crit_chance", 0),
			"player_defense": save.get("player_defense", 0),
			"current_skill_point": save.get("current_skill_point", 0),
			"inventory": {
				"equipped": save.get("equipped_item", ""),
				"items": JSON.parse_string(save.get("inventory_items", "[]"))
			},
			"stages": {}
		}
		
		var stages = save.get("stages_completed", [])
		for stage in stages:
			save_data[stage] = true
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string(JSON.stringify(save_data))
		file.close()
	
	callback.call(true, "Saves restaurados com sucesso!")

func _upload_save(slot: int, save_data: Dictionary) -> void:
	var http = HTTPRequest.new()
	add_child(http)
	
	# Extrai fases completadas
	var stages: Array = []
	for key in save_data:
		if key.begins_with("W") and save_data[key] == true:
			stages.append(key)
	
	var inventory = save_data.get("inventory", {})
	
	var body = JSON.stringify({
		"player_id": PlayerIdManager.player_id,
		"slot": slot,
		"player_name": save_data.get("player_name", ""),
		"experience": save_data.get("experience", 0),
		"memory": save_data.get("memory", 0),
		"agility": save_data.get("agility", 0),
		"focus": save_data.get("focus", 0),
		"reasoning": save_data.get("reasoning", 0),
		"coordination": save_data.get("coordination", 0),
		"player_health": save_data.get("player_health", 0),
		"player_time": save_data.get("player_time", 0),
		"player_damage": save_data.get("player_damage", 0),
		"player_crit_chance": save_data.get("player_crit_chance", 0),
		"player_defense": save_data.get("player_defense", 0),
		"current_skill_point": save_data.get("current_skill_point", 0),
		"equipped_item": inventory.get("equipped", ""),
		"inventory_items": JSON.stringify(inventory.get("items", [])),
		"stages_completed": stages,
		"updated_at": Time.get_datetime_string_from_system()
	})
	
	var headers = _get_headers("resolution=merge-duplicates")
	http.request_completed.connect(_on_request_done.bind(http, "save"))
	
	if http.request(supabase_url + "/rest/v1/saves", headers, HTTPClient.METHOD_POST, body) != OK:
		http.queue_free()

func submit_leaderboard(xp: int, player_name: String) -> void:
	if not is_configured():
		return
	
	var http = HTTPRequest.new()
	add_child(http)
	
	var body = JSON.stringify({
		"player_id": PlayerIdManager.player_id,
		"player_name": player_name,
		"xp": xp,
		"updated_at": Time.get_datetime_string_from_system()
	})
	
	var headers = _get_headers("resolution=merge-duplicates")
	http.request_completed.connect(_on_request_done.bind(http, "leaderboard"))
	
	if http.request(supabase_url + "/rest/v1/leaderboard", headers, HTTPClient.METHOD_POST, body) != OK:
		http.queue_free()

func fetch_leaderboard(callback: Callable) -> void:
	if not is_configured():
		callback.call([])
		return
	
	var http = HTTPRequest.new()
	add_child(http)
	
	var headers = _get_headers()
	http.request_completed.connect(_on_fetch_done.bind(http, callback))
	
	if http.request(supabase_url + "/rest/v1/leaderboard?order=xp.desc&limit=10", headers, HTTPClient.METHOD_GET) != OK:
		callback.call([])
		http.queue_free()

func _get_headers(prefer: String = "") -> PackedStringArray:
	var headers = PackedStringArray([
		"Content-Type: application/json",
		"apikey: " + supabase_key,
		"Authorization: Bearer " + supabase_key
	])
	if prefer != "":
		headers.append("Prefer: " + prefer)
	return headers

func _on_request_done(result, response_code, headers, body, http, type):
	if response_code in [200, 201]:
		print("Online sync OK: ", type)
	else:
		print("Online sync falhou (", response_code, ")")
		print("Body: ", body.get_string_from_utf8())
	http.queue_free()

func _on_fetch_done(result, response_code, headers, body, http, callback: Callable):
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		callback.call(json.data)
	else:
		callback.call([])
	http.queue_free()
