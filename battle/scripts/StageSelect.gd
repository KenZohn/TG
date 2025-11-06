extends Control

func _ready():
	State.reset_state()
	update_stages()
	show_stats()

func _on_m_1_pressed() -> void:
	State.stage = "m1"
	State.game = "bomb"
	State.enemy = "slime"
	State.memory = 3
	change_scene_battle()

func _on_m_2_pressed() -> void:
	State.stage = "m2"
	State.game = "bomb"
	State.enemy = "zombie"
	State.memory = 4
	change_scene_battle()

func _on_m_3_pressed() -> void:
	State.stage = "m3"
	State.game = "bomb"
	State.enemy = "goblin"
	State.memory = 5
	change_scene_battle()

func _on_a_1_pressed() -> void:
	State.stage = "a1"
	State.game = "color"
	State.enemy = "slime"
	State.agility = 3
	change_scene_battle()

func _on_a_2_pressed() -> void:
	State.stage = "a2"
	State.game = "color"
	State.enemy = "zombie"
	State.agility = 4
	change_scene_battle()

func _on_a_3_pressed() -> void:
	State.stage = "a3"
	State.game = "color"
	State.enemy = "goblin"
	State.agility = 5
	change_scene_battle()

func _on_f_1_pressed() -> void:
	State.stage = "f1"
	State.game = "react"
	State.enemy = "slime"
	State.focus = 3
	change_scene_battle()

func _on_f_2_pressed() -> void:
	State.stage = "f2"
	State.game = "react"
	State.enemy = "zombie"
	State.focus = 4
	change_scene_battle()

func _on_f_3_pressed() -> void:
	State.stage = "f3"
	State.game = "react"
	State.enemy = "goblin"
	State.focus = 5
	change_scene_battle()

func _on_f_4_pressed() -> void:
	State.stage = "f4"
	State.game = "sort"
	State.enemy = "slime"
	State.focus = 3
	change_scene_battle()

func _on_f_5_pressed() -> void:
	State.stage = "f5"
	State.game = "sort"
	State.enemy = "zombie"
	State.focus = 4
	change_scene_battle()

func _on_c_1_pressed() -> void:
	State.stage = "c1"
	State.game = "reflex"
	State.enemy = "slime"
	State.coordination = 3
	change_scene_battle()

func _on_c_2_pressed() -> void:
	State.stage = "c2"
	State.game = "reflex"
	State.enemy = "zombie"
	State.coordination = 4
	change_scene_battle()

func _on_c_3_pressed() -> void:
	State.stage = "c3"
	State.game = "reflex"
	State.enemy = "goblin"
	State.coordination = 5
	change_scene_battle()
	

func _on_r_1_pressed() -> void:
	State.stage = "r1"
	State.game = "pop"
	State.enemy = "slime"
	State.reasoning = 3
	change_scene_battle()
	

func _on_tittle_screen_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/TitleScreen.tscn")

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
		"f3": $F3,
		"f4": $F4,
		"f5": $F5,
		"c1": $C1,
		"c2": $C2,
		"c3": $C3
	}
	for key in stage_map.keys():
		if key in State.save_data and State.save_data[key]:
			stage_map[key].modulate = Color(0, 1, 0) # verde

func show_stats():
	$LabelMemory.text = str(int(State.save_data["memory"]))
	$LabelAgility.text = str(int(State.save_data["agility"]))
	$LabelFocus.text = str(int(State.save_data["focus"]))
	$LabelReasoning.text = str(int(State.save_data["reasoning"]))
	$LabelCoordination.text = str(int(State.save_data["coordination"]))

func change_scene_battle():
	FadeLayer.fade_to_scene("res://scenes/Battle.tscn")
