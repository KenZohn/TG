extends Control

var save_data = {}

func _ready():
	GameState.save_data = load_game()
	#save_game()
	update_stages()

func _on_m_1_pressed() -> void:
	pass

func _on_a_1_pressed() -> void:
	GameState.stage = "a1"
	GameState.game = "color"
	GameState.enemy = "slime"
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_a_2_pressed() -> void:
	GameState.stage = "a2"
	GameState.game = "color"
	GameState.enemy = "zombie"
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_a_3_pressed() -> void:
	GameState.stage = "a3"
	GameState.game = "color"
	GameState.enemy = "zombie"
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_f_1_pressed() -> void:
	GameState.stage = "f1"
	GameState.game = "react"
	GameState.enemy = "slime"
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_f_2_pressed() -> void:
	GameState.stage = "f2"
	GameState.game = "react"
	GameState.enemy = "zombie"
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_f_3_pressed() -> void:
	GameState.stage = "f3"
	GameState.game = "react"
	GameState.enemy = "zombie"
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_tittle_screen_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")

func load_game():
	if FileAccess.file_exists("res://saves/save1.save"):
		var file = FileAccess.open("res://saves/save1.save", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data
	else:
		#return progresso # estrutura inicial
		return {
			"m1": {"cleared": false},
			"m2": {"cleared": false},
			"m3": {"cleared": false},
			"a1": {"cleared": false},
			"a2": {"cleared": false},
			"a3": {"cleared": false},
			"f1": {"cleared": false},
			"f2": {"cleared": false},
			"f3": {"cleared": false}
	 	}

func update_stages():
	if "m1" in GameState.save_data and GameState.save_data["m1"]["cleared"]:
		$M1.modulate = Color(0, 1, 0) # verde
	
	if "a1" in GameState.save_data and GameState.save_data["a1"]["cleared"]:
		$A1.modulate = Color(0, 1, 0) # verde
	
	if "a2" in GameState.save_data and GameState.save_data["a2"]["cleared"]:
		$A2.modulate = Color(0, 1, 0) # verde
	
	if "a3" in GameState.save_data and GameState.save_data["a3"]["cleared"]:
		$A3.modulate = Color(0, 1, 0) # verde
	
	if "f1" in GameState.save_data and GameState.save_data["f1"]["cleared"]:
		$F1.modulate = Color(0, 1, 0) # verde
	
	if "f2" in GameState.save_data and GameState.save_data["f2"]["cleared"]:
		$F2.modulate = Color(0, 1, 0) # verde
	
	if "f3" in GameState.save_data and GameState.save_data["f3"]["cleared"]:
		$F3.modulate = Color(0, 1, 0) # verde

func save_game():
	var file = FileAccess.open("res://saves/save1.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	file.store_string(json_string)
	file.close()
