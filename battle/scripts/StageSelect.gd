extends Control

func _on_a_1_pressed() -> void:
	GameState.game = "react"
	GameState.enemy = "slime"
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

#func _on_m_1_pressed() -> void:
#	GameState.game = "memory"
#	GameState.enemy = "slime"
#	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_a_2_pressed() -> void:
	GameState.game = "color"
	GameState.enemy = "zombie"
	get_tree().change_scene_to_file("res://scenes/Battle.tscn")

func _on_tittle_screen_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")
