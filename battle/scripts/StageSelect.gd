extends Control

var save_data = {}

func _ready():
	GameState.save_data = load_game()
	#save_game()
	reset_state()
	update_stages()
	show_stats()

func reset_state():
	GameState.memory = 0
	GameState.agility = 0
	GameState.focus = 0
	GameState.reasoning = 0
	GameState.coordination = 0

func _on_m_1_pressed() -> void:
	GameState.stage = "m1"
	GameState.game = "bomb"
	GameState.enemy = "slime"
	
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_a_1_pressed() -> void:
	GameState.stage = "a1"
	GameState.game = "color"
	GameState.enemy = "slime"
	
	GameState.agility = 3
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_a_2_pressed() -> void:
	GameState.stage = "a2"
	GameState.game = "color"
	GameState.enemy = "zombie"
	
	GameState.agility = 4
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_a_3_pressed() -> void:
	GameState.stage = "a3"
	GameState.game = "color"
	GameState.enemy = "zombie"
	
	GameState.agility = 5
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_f_1_pressed() -> void:
	GameState.stage = "f1"
	GameState.game = "react"
	GameState.enemy = "slime"
	
	GameState.focus = 3
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_f_2_pressed() -> void:
	GameState.stage = "f2"
	GameState.game = "react"
	GameState.enemy = "zombie"
	
	GameState.focus = 4
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_f_3_pressed() -> void:
	GameState.stage = "f3"
	GameState.game = "react"
	GameState.enemy = "zombie"
	
	GameState.focus = 5
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
		var initial_data = {
			"memory": 0,
			"agility": 0,
			"focus": 0,
			"reasoning": 0,
			"coordination": 0
		}
		
		for prefix in ["m", "a", "f", "r", "c"]:
			for i in range(1, 13):
				initial_data["%s%d" % [prefix, i]] = false
		
		return initial_data

func update_stages():
	if "m1" in GameState.save_data and GameState.save_data["m1"]:
		$M1.modulate = Color(0, 1, 0) # verde
	
	if "a1" in GameState.save_data and GameState.save_data["a1"]:
		$A1.modulate = Color(0, 1, 0) # verde
	
	if "a2" in GameState.save_data and GameState.save_data["a2"]:
		$A2.modulate = Color(0, 1, 0) # verde
	
	if "a3" in GameState.save_data and GameState.save_data["a3"]:
		$A3.modulate = Color(0, 1, 0) # verde
	
	if "f1" in GameState.save_data and GameState.save_data["f1"]:
		$F1.modulate = Color(0, 1, 0) # verde
	
	if "f2" in GameState.save_data and GameState.save_data["f2"]:
		$F2.modulate = Color(0, 1, 0) # verde
	
	if "f3" in GameState.save_data and GameState.save_data["f3"]:
		$F3.modulate = Color(0, 1, 0) # verde

func show_stats():
	$LabelMemory.text = "Memória: " + str(int(GameState.save_data["memory"]))
	$LabelAgility.text = "Agilidade: " + str(int(GameState.save_data["agility"]))
	$LabelFocus.text = "Foco: " + str(int(GameState.save_data["focus"]))
	$LabelReasoning.text = "Raciocínio: " + str(int(GameState.save_data["reasoning"]))
	$LabelCoordination.text = "Coordenação: " + str(int(GameState.save_data["coordination"]))

func save_game():
	var file = FileAccess.open("res://saves/save1.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	file.store_string(json_string)
	file.close()
