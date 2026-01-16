extends Control

signal correct_answer_hit(damage)
signal game_finished()
signal timer_update(time)

@onready var spawn_timer = $TimerSpawn
@onready var spawn_area = $SpawnArea

var current_button: Node = null
var damage = 2

func _ready():
	spawn_timer.start()
	setup_timers()
	start_game()
	$TimerDisplay.timeout.connect(_update_timer_display)

func start_game():
	$TimerGame.start()

func _on_spawn_timer_timeout() -> void:
	if current_button and current_button.is_inside_tree():
		current_button.queue_free()
	
	var button_scene = preload("res://scenes/reflex_button.tscn")
	var button_instance = button_scene.instantiate()
	
	# Referência ao ColorRect
	var area_rect = spawn_area.get_node("ColorRect")
	area_rect.add_child(button_instance)  # Adiciona ao ColorRect
	
	# Calcula posição local dentro do ColorRect
	var area_size = area_rect.size
	var margin = 50.0
	var x = randf_range(margin, area_size.x - margin)
	var y = randf_range(margin, area_size.y - margin)
	button_instance.position = Vector2(x, y)
	
	button_instance.connect("target_pressed", _on_button_pressed)
	current_button = button_instance

func _on_button_pressed(_reaction_time):
	emit_signal("correct_answer_hit", damage)

func setup_timers():
	$TimerGame.wait_time = State.time
	$TimerGame.one_shot = true
	$TimerGame.timeout.connect(_on_game_timeout)
	
	$TimerInterval.wait_time = 0.1
	$TimerInterval.one_shot = true
	$TimerInterval.timeout.connect(_on_interval_timeout)
	
	$TimerDisplay.wait_time = 0.1
	$TimerDisplay.one_shot = false
	$TimerDisplay.start()

func _update_timer_display():
	var remaining = $TimerGame.time_left
	emit_signal("timer_update", remaining)

func _on_interval_timeout():
	if $TimerGame.is_stopped():
		return

func _on_game_timeout():
	spawn_timer.stop()
	
	if current_button and current_button.is_inside_tree():
		current_button.queue_free()
	
	emit_signal("game_finished")
