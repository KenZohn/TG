extends Node

func new_game(path):
	var save_data = {
		"player_name": '',
		"experience": 0,
		"skill_points": 0,
		"inventory": {"items": [], "equipped": ""},
		
		# Apagar depois que não for usar mais.
		"memory": 0,
		"agility": 0,
		"focus": 0,
		"reasoning": 0,
		"coordination": 0,
	}
	
	# Apagar depois que alterar para as fases mescladas
	for prefix in ["m", "a", "f", "r", "c"]:
		for i in range(1, 13):
			save_data["%s%d" % [prefix, i]] = false
	
	for i in range(1, 61):
		save_data["stage_%d" % i] = false
	
	# Salva os dados zerados
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	file.store_string(json_string)
	file.close()
	
	# Atualiza o estado global
	State.save_data = save_data
	State.reset_state()
	State.reset_position()
	
func load_game(path):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		State.save_data = JSON.parse_string(file.get_as_text())
		file.close()
		State.inventory.deserialize(State.save_data.get("inventory", {}))
		return true
	return false
	
func save_game(path):
	State.save_data["inventory"] = State.inventory.serialize() 
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(State.save_data))
	file.close()
