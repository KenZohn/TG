extends Node

var player_id: String = ""

func _ready():
	player_id = load_or_create_id()

func load_or_create_id() -> String:
	var path = "user://player_id.txt"
	
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var id = file.get_as_text().strip_edges()
		file.close()
		return id
	
	var new_id = "%d_%d" % [Time.get_unix_time_from_system(), randi()]
	save_id(new_id)
	return new_id

func save_id(id: String) -> void:
	var path = "user://player_id.txt"
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(id)
	file.close()

func override_id(new_id: String) -> void:
	player_id = new_id
	save_id(new_id)
	print("Player ID alterado para: ", new_id)
