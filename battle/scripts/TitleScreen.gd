extends Control
var save_data = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_new_pressed() -> void:
	State.is_new_game = true
	get_tree().change_scene_to_file("res://scenes/LoadScreen.tscn")
	
func _on_load_pressed() -> void:
	# Supposed to open the world map (we don't have one yet :c) 
	State.is_new_game = false
	get_tree().change_scene_to_file("res://scenes/LoadScreen.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
	
