extends Node

func new_game(path):
	var save_data = {
		"player_name": '',
		"stages": {},
		"experience": 0,
		"inventory": {"items": [], "equipped": ""},
		
		"player_health": 0,
		"player_time": 0,
		"player_damage": 0,
		"player_crit_chance": 0,
		"player_defense": 0,
		"current_skill_point": 0,
	}
	
	# Salva os dados zerados
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	file.store_string(json_string)
	file.close()
	
	# Atualiza o estado global
	State.save_data = save_data
	
func load_game(path):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		State.save_data = JSON.parse_string(file.get_as_text())
		file.close()
		State.inventory.deserialize(State.save_data.get("inventory", {}))
		
		State.player_health = State.save_data["player_health"]
		State.player_time = State.save_data["player_time"]
		State.player_damage = State.save_data["player_damage"]
		State.player_crit_chance = State.save_data["player_crit_chance"]
		State.player_defense = State.save_data["player_defense"]
		State.current_skill_point = State.save_data["current_skill_point"]
		
		create_player_position_for_save() # Para que o save antigo funcione. Deletar quando atualizar todos.
		var pos = State.save_data["player_position"]
		State.player_position = Vector2(pos["x"], pos["y"])
		
		State.skills = {
			"Start": true
		}
		
		for key in State.save_data:
			if key.begins_with("Skill_"):
				State.skills[key] = State.save_data[key]
		create_stages_for_save() # Para que o save antigo funcione. Deletar quando atualizar todos.
		return true
	return false
	
func save_game(path):
	State.save_data["inventory"] = State.inventory.serialize()
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(State.save_data))
	file.close()
	
	var slot = 1
	if "save2" in path: slot = 2
	elif "save3" in path: slot = 3
	
	OnlineManager.sync_save(slot, State.save_data)
	OnlineManager.submit_leaderboard(
		int(State.save_data.get("experience", 0)),
		State.save_data.get("player_name", "Anônimo")
	)

# Para que o save antigo funcione. Deletar quando atualizar todos.
func create_stages_for_save():
	if !State.save_data.has("stages"):
		State.save_data["stages"] = {}
# Para que o save antigo funcione. Deletar quando atualizar todos.
func create_player_position_for_save():
	if !State.save_data.has("player_position"):
		State.save_data["player_position"] = Vector2.ZERO
