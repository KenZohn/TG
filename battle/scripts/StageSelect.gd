extends Control

#var save_data = {}

func _ready():
	State.reset_state()
	update_stages()
	show_stats()


func _on_m_1_pressed() -> void:
	State.stage = "m1"
	State.game = "bomb"
	State.enemy = "slime"
	
	State.memory = 3
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_m_2_pressed() -> void:
	State.stage = "m2"
	State.game = "bomb"
	State.enemy = "zombie"
	
	State.memory = 4
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_m_3_pressed() -> void:
	State.stage = "m3"
	State.game = "bomb"
	State.enemy = "goblin"
	
	State.memory = 5
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_a_1_pressed() -> void:
	State.stage = "a1"
	State.game = "color"
	State.enemy = "slime"
	
	State.agility = 3
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_a_2_pressed() -> void:
	State.stage = "a2"
	State.game = "color"
	State.enemy = "zombie"
	
	State.agility = 4
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_a_3_pressed() -> void:
	State.stage = "a3"
	State.game = "color"
	State.enemy = "goblin"
	
	State.agility = 5
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_f_1_pressed() -> void:
	State.stage = "f1"
	State.game = "react"
	State.enemy = "slime"
	
	State.focus = 3
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_f_2_pressed() -> void:
	State.stage = "f2"
	State.game = "react"
	State.enemy = "zombie"
	
	State.focus = 4
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_f_3_pressed() -> void:
	State.stage = "f3"
	State.game = "react"
	State.enemy = "goblin"
	
	State.focus = 5
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_tittle_screen_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")

func update_stages():
	var stage_map = {
		"m1": $M1,
		"m2": $M2,
		"m3": $M3,
		"a1": $A1,
		"a2": $A2,
		"a3": $A3,
		"f1": $F1,
		"f2": $F2,
		"f3": $F3
	}
	for key in stage_map.keys():
		if key in State.save_data and State.save_data[key]:
			stage_map[key].modulate = Color(0, 1, 0) # verde

func show_stats():
	$LabelMemory.text = "Memória: " + str(int(State.save_data["memory"]))
	$LabelAgility.text = "Agilidade: " + str(int(State.save_data["agility"]))
	$LabelFocus.text = "Foco: " + str(int(State.save_data["focus"]))
	$LabelReasoning.text = "Raciocínio: " + str(int(State.save_data["reasoning"]))
	$LabelCoordination.text = "Coordenação: " + str(int(State.save_data["coordination"]))

func save_game():
	var file = FileAccess.open(State.save_path, FileAccess.WRITE)
	var json_string = JSON.stringify(State.save_data)
	file.store_string(json_string)
	file.close()
