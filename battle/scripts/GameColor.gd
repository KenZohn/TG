extends Control

signal correct_answer_hit(damage)
signal game_finished(score)

var color_map = {
	"Vermelho": Color.RED,
	"Azul": Color.BLUE,
	"Verde": Color.GREEN,
	"Amarelo": Color.YELLOW
}

var correct_answer: bool = false
var score: int = 0
var awaiting_response: bool = false

func _ready():
	connect_buttons()
	setup_timers()
	start_game()
	$TimerDisplay.timeout.connect(_update_timer_display)

func _update_timer_display():
	var remaining = $TimerGame.time_left
	$ProgressBarTimer/Label.text = "%.1f" % remaining
	$ProgressBarTimer.value = remaining

func setup_timers():
	$TimerGame.wait_time = 15.0 + State.save_data["agility"] * 0.05
	$TimerGame.one_shot = true
	$TimerGame.timeout.connect(_on_game_timeout)
	
	$TimerInterval.wait_time = 0.1
	$TimerInterval.one_shot = true
	$TimerInterval.timeout.connect(_on_interval_timeout)
	
	$TimerDisplay.wait_time = 0.1
	$TimerDisplay.one_shot = false
	$TimerDisplay.start()

func start_game():
	$TimerGame.start()
	$ProgressBarTimer.max_value = $TimerGame.wait_time
	$ProgressBarTimer.value = $TimerGame.wait_time
	generate_challenge()

func generate_challenge():
	var names = color_map.keys()
	var meaning = names[randi() % names.size()]
	var color_text = names[randi() % names.size()]
	var text_color = color_map[names[randi() % names.size()]]
	
	$Panel/LabelMeaning.text = meaning
	$Panel/LabelColor.text = color_text
	$Panel/LabelColor.add_theme_color_override("font_color", text_color)
	
	correct_answer = color_map[meaning] == text_color
	awaiting_response = true
	
	$Panel/ButtonYes.disabled = false
	$Panel/ButtonNo.disabled = false

func connect_buttons():
	$Panel/ButtonYes.pressed.connect(func(): _on_user_response(true))
	$Panel/ButtonNo.pressed.connect(func(): _on_user_response(false))

func _on_user_response(response: bool):
	if not awaiting_response:
		return
	
	awaiting_response = false
	$Panel/ButtonYes.disabled = true
	$Panel/ButtonNo.disabled = true
	
	if response == correct_answer:
		score += 1
		print("✅ Correct!")
		emit_signal("correct_answer_hit", int(2 + 2 * State.save_data["focus"] * 0.05))
	else:
		print("❌ Wrong!")
		_apply_time_penalty()
	
	$TimerInterval.start()

func _apply_time_penalty():
	var remaining = $TimerGame.time_left
	var new_time = max(remaining - 2.0, 0.1) # Evita tempo zero ou negativo
	$TimerGame.stop()
	$TimerGame.wait_time = new_time
	$TimerGame.start()

func _on_interval_timeout():
	if $TimerGame.is_stopped():
		return
	generate_challenge()

func _on_game_timeout():
	$TimerInterval.stop()
	awaiting_response = false
	
	$Panel/ButtonYes.disabled = true
	$Panel/ButtonNo.disabled = true
	$Panel/LabelMeaning.text = "Time's up!"
	$Panel/LabelColor.text = "Score: %d" % score
	
	emit_signal("game_finished", false)
