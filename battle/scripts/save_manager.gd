extends Node

func new_game(path):
	var save_data = {
		"memory": 0,
		"agility": 0,
		"focus": 0,
		"reasoning": 0,
		"coordination": 0,
		"experience": 0
	}
	
	for prefix in ["m", "a", "f", "r", "c"]:
		for i in range(1, 13):
			save_data["%s%d" % [prefix, i]] = false
	
	# Salva os dados zerados
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	file.store_string(json_string)
	file.close()
	
	# Atualiza o estado global
	State.save_data = save_data
	State.reset_state()
	
func load_game(path):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		State.save_data = JSON.parse_string(file.get_as_text())
		file.close()
		return true
	return false
	
func save_game(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(State.save_data))
	file.close()
