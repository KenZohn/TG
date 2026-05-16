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
		
		State.skills = {
			"Start": true
		}
		
		for key in State.save_data:
			if key.begins_with("Skill_"):
				State.skills[key] = State.save_data[key]
		
		return true
	return false
	
func save_game(path):
	State.save_data["inventory"] = State.inventory.serialize()
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(State.save_data))
	file.close()
