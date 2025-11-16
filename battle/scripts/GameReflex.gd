extends Control

signal correct_answer_hit(damage)
signal game_finished(score)

@onready var spawn_timer = $TimerSpawn
@onready var spawn_area = $SpawnArea

var score = 0
var current_button: Node = null

var totalTime = 15.0 + State.save_data["agility"] * 0.05

func _ready():
	$ProgressBarTimer/Label.text = "%.1f" % totalTime
	
	spawn_timer.start()
	setup_timers()
	start_game()
	$TimerDisplay.timeout.connect(_update_timer_display)

func start_game():
	$TimerGame.start()
	$ProgressBarTimer.max_value = $TimerGame.wait_time
	$ProgressBarTimer.value = $TimerGame.wait_time

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
	emit_signal("correct_answer_hit", int(2 + 2 * State.save_data["focus"] * 0.05))

func setup_timers():
	$TimerGame.wait_time = totalTime
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
	$ProgressBarTimer/Label.text = "%.1f" % remaining
	$ProgressBarTimer.value = remaining

func _on_interval_timeout():
	if $TimerGame.is_stopped():
		return

func _on_game_timeout():
	spawn_timer.stop()
	
	if current_button and current_button.is_inside_tree():
		current_button.queue_free()
	
	emit_signal("game_finished", false)
