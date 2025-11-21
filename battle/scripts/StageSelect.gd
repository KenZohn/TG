extends Control

func _ready():
	BGMManager.stop_bgm()
	State.reset_state()
	update_stages()
	set_state()
	
	for b in get_tree().get_nodes_in_group("menu_buttons"):
		b.connect("pressed", Callable(self, "_on_any_button_pressed"))

func _on_m_1_pressed() -> void:
	State.stage = "m1"
	State.game = "bomb"
	State.enemy = "slime"
	State.memory = 3
	battle_scene()

func _on_m_2_pressed() -> void:
	State.stage = "m2"
	State.game = "bomb"
	State.enemy = "zombie"
	State.memory = 4
	battle_scene()

func _on_m_3_pressed() -> void:
	State.stage = "m3"
	State.game = "bomb"
	State.enemy = "goblin"
	State.memory = 5
	battle_scene()

func _on_a_1_pressed() -> void:
	State.stage = "a1"
	State.game = "color"
	State.enemy = "slime"
	State.agility = 3
	battle_scene()

func _on_a_2_pressed() -> void:
	State.stage = "a2"
	State.game = "color"
	State.enemy = "zombie"
	State.agility = 4
	battle_scene()

func _on_a_3_pressed() -> void:
	State.stage = "a3"
	State.game = "color"
	State.enemy = "goblin"
	State.agility = 5
	battle_scene()

func _on_f_1_pressed() -> void:
	State.stage = "f1"
	State.game = "react"
	State.enemy = "slime"
	State.focus = 3
	battle_scene()

func _on_f_2_pressed() -> void:
	State.stage = "f2"
	State.game = "react"
	State.enemy = "zombie"
	State.focus = 4
	battle_scene()

func _on_f_3_pressed() -> void:
	State.stage = "f3"
	State.game = "react"
	State.enemy = "goblin"
	State.focus = 5
	battle_scene()

func _on_f_4_pressed() -> void:
	State.stage = "f4"
	State.game = "sort"
	State.enemy = "slime"
	State.focus = 3
	battle_scene()

func _on_f_5_pressed() -> void:
	State.stage = "f5"
	State.game = "sort"
	State.enemy = "zombie"
	State.focus = 4
	battle_scene()

func _on_c_1_pressed() -> void:
	State.stage = "c1"
	State.game = "reflex"
	State.enemy = "slime"
	State.coordination = 3
	battle_scene()

func _on_c_2_pressed() -> void:
	State.stage = "c2"
	State.game = "reflex"
	State.enemy = "zombie"
	State.coordination = 4
	battle_scene()

func _on_c_3_pressed() -> void:
	State.stage = "c3"
	State.game = "reflex"
	State.enemy = "goblin"
	State.coordination = 5
	battle_scene()

func _on_r_1_pressed() -> void:
	State.stage = "r1"
	State.game = "pop"
	State.enemy = "slime"
	State.reasoning = 3
	battle_scene()

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
		"c3": $C3,
		"r1": $R1
	}
	for key in stage_map.keys():
		if key in State.save_data and State.save_data[key]:
			stage_map[key].modulate = Color(0, 1, 0) # verde

func set_state():
	State.max_hp = 50 + 100 * State.save_data["memory"] * 0.01
	State.time = 15 + 5 * State.save_data["agility"] * 0.01
	State.damage_multiplier = 1 + 2 * State.save_data["focus"] * 0.01
	State.critical = 10 * State.save_data["coordination"] * 0.01
	State.defense = 10 * State.save_data["reasoning"] * 0.01

func battle_scene():
	FadeLayer.fade_to_scene("res://scenes/Battle.tscn")

func _on_any_button_pressed():
	SESelect.play()
