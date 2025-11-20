extends Control

func _on_continue_pressed():
	get_tree().paused = false
	visible = false

func _on_map_pressed():
	get_tree().paused = false
	FadeLayer.fade_to_scene("res://scenes/StageSelect.tscn")

func _on_exit_pressed():
	get_tree().paused = false
	FadeLayer.fade_to_scene("res://scenes/TitleScreen.tscn")
