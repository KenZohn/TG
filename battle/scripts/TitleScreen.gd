extends Control
var save_data = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_new_pressed() -> void:
	new_game()
	get_tree().change_scene_to_file("res://scenes/StageSelect.tscn")
	
func _on_start_pressed() -> void:
	# Supposed to open the world map (we don't have one yet :c) 
	get_tree().change_scene_to_file("res://scenes/LoadScreen.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func new_game():
	save_data = {
		"memory": 0,
		"agility": 0,
		"focus": 0,
		"reasoning": 0,
		"coordination": 0
	}
	
	for prefix in ["m", "a", "f", "r", "c"]:
		for i in range(1, 13):
			save_data["%s%d" % [prefix, i]] = false
	
	# Salva os dados zerados
	var file = FileAccess.open("res://saves/save1.save", FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	file.store_string(json_string)
	file.close()
	
	# Atualiza o estado global
	State.save_data = save_data
	State.reset_state()
