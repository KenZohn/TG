extends Control

func _ready():
	for b in get_tree().get_nodes_in_group("se_buttons"):
		b.connect("pressed", Callable(self, "_on_any_button_pressed"))
		b.connect("mouse_entered", Callable(self, "_on_any_button_entered"))

func _on_continue_pressed():
	get_tree().paused = false
	visible = false

func _on_map_pressed():
	get_tree().paused = false
	#FadeLayer.fade_to_scene("res://scenes/stage_select.tscn")
	FadeLayer.fade_to_scene("res://scenes/mapa.tscn")

func _on_exit_pressed():
	get_tree().paused = false
	FadeLayer.fade_to_scene("res://scenes/title_screen.tscn")

func _on_any_button_pressed():
	SESelect.play()

func _on_any_button_entered():
	SEMouseEntered.play()
