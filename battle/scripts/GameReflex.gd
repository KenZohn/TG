extends Control

signal correct_answer_hit(damage)
signal game_finished(score)

@onready var spawn_timer = $CanvasLayer/TimerSpawn
@onready var score_label = $CanvasLayer/LabelScore
@onready var spawn_area = $SpawnArea
@onready var game_timer = $CanvasLayer/TimerGame
@onready var timer_display = $CanvasLayer/TimerDisplay
@onready var label_timer = $CanvasLayer/LabelTimer

var score = 0
var current_button: Node = null

func _ready():
	game_timer.wait_time = 15.0
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_game_timeout)
	
	timer_display.timeout.connect(_update_timer_display)
	timer_display.start()
	
	game_timer.start()
	
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	if current_button and current_button.is_inside_tree():
		current_button.queue_free()
	
	var button_scene = preload("res://scenes/ReflexButton.tscn")
	var button_instance = button_scene.instantiate()
	
	# Referência ao ColorRect
	var area_rect = spawn_area.get_node("ColorRect")
	area_rect.add_child(button_instance)  # ✅ Adiciona ao ColorRect
	
	# Calcula posição local dentro do ColorRect
	var area_size = area_rect.size
	var margin = 50.0  # margem interna para evitar corte nas bordas
	var x = randf_range(margin, area_size.x - margin)
	var y = randf_range(margin, area_size.y - margin)
	button_instance.position = Vector2(x, y)  # ✅ Posição local
	
	button_instance.connect("target_pressed", _on_button_pressed)
	current_button = button_instance

func _on_button_pressed(_reaction_time):
	score += 1
	score_label.text = "Score: %d" % score
	emit_signal("correct_answer_hit", int(2 + 2 * State.save_data["focus"] * 0.05))

func _update_timer_display():
	var remaining = game_timer.time_left
	label_timer.text = "%.1f" % remaining

func _on_game_timeout():
	spawn_timer.stop()
	timer_display.stop()
	
	if current_button and current_button.is_inside_tree():
		current_button.queue_free()
	
	score_label.text = "Tempo esgotado! Pontuação: %d" % score
	emit_signal("game_finished", false)
