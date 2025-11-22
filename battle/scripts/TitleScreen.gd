extends Control
var save_data = {}

@onready var titulo = $"MarginContainer/HBoxContainer/VBoxContainer/Titulo"
@onready var subtitulo = $"MarginContainer/HBoxContainer/VBoxContainer/Subtítulo"

@onready var press_start = $Start

func _ready() -> void:
	BGMManager.play_bgm(load("res://assets/bgm/(TitleMenu)maou_bgm_acoustic48.mp3"))
	
	var title_tween = create_tween()
	var subtitle_tween = create_tween()
	
	titulo.modulate.a = 0.0 
	title_tween.tween_property(titulo, "modulate:a", 1.0, 1.0).set_ease(Tween.EASE_OUT)
	titulo.scale = Vector2(0.8, 0.8)
	title_tween.parallel().tween_property(titulo, "scale", Vector2(1.0, 1.0), 1.0).set_ease(Tween.EASE_OUT)
	
	subtitulo.modulate.a = 0.0
	subtitle_tween.tween_interval(0.5) 
	subtitle_tween.tween_property(subtitulo, "modulate:a", 1.0, 1.0)
	
	animate_press_start()

func _on_new_pressed() -> void:
	State.is_new_game = true
	get_tree().change_scene_to_file("res://scenes/LoadScreen.tscn")
	
func _on_load_pressed() -> void:
	# Supposed to open the world map (we don't have one yet :c)
	State.is_new_game = false
	get_tree().change_scene_to_file("res://scenes/LoadScreen.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Options.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/CreditsScreen.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
	

func animate_press_start():
	press_start.modulate.a = 0.0
	var tween = create_tween().set_loops()
	tween.tween_property(press_start, "modulate:a", 0.1, 0.5)
	tween.tween_property(press_start, "modulate:a", 0.9, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(press_start, "modulate:a", 0.1, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
