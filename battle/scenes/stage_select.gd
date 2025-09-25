extends Control

func _on_a_1_pressed() -> void:
	GameState.game = "agility1"
	GameState.enemy = "slime"
	get_tree().change_scene_to_file("res://scenes/battle.tscn")


func _on_m_1_pressed() -> void:
	GameState.game = "sudoku3x3"
	GameState.enemy = "slime"
	get_tree().change_scene_to_file("res://scenes/battle.tscn")


func _on_tittle_screen_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
