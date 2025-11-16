extends Control

signal correct_answer_hit(damage)
signal game_finished(score)

@onready var game_area = $Area

var colors = [
	Color(0.8, 0.2, 0.2, 0.7),
	Color(0.2, 0.6, 0.2, 0.7),
	Color(0.2, 0.2, 0.8, 0.7),
	Color(0.8, 0.8, 0.2, 0.7),
	Color(0.6, 0.2, 0.6, 0.7) 
]

var numbers = []
var buttons = []

var totalTime = 15.0 + State.save_data["agility"] * 0.05

func _ready():
	#style.set_corner_radius_all(25)
	setup_timers()
	start_game()
	
func start_game():
	numbers.clear()
	buttons.clear()
	while numbers.size() < 5:
		# Number between -100 and 100
		var num = randi() % 201 - 100
		if not numbers.has(num):
			numbers.append(num)
	numbers.sort()
	print("Numeros gerados:", numbers)
	
	for i in (numbers.size()):
		var num = numbers[i]
		var button = Button.new()
		button.text = str(num)
		button.set_size(Vector2(50, 50))
		
		var style = StyleBoxFlat.new()
		style.bg_color = colors[i]
		
		style.set_border_width_all(2)
		style.border_color = style.bg_color.darkened(0.2) 
		
		var hover_color = colors[i].darkened(0.2) 
		var style_hover = style.duplicate()
		style_hover.bg_color = hover_color
		
		button.add_theme_stylebox_override("normal", style)
		button.add_theme_stylebox_override("hover", style_hover)
		button.add_theme_stylebox_override("pressed", style)
		button.add_theme_color_override("font_color", Color.WHITE)
		
		button.set_position(get_valid_position())
		print("Botão", num, "posição:", button.position)
		
		button.connect("pressed", Callable(self, "_on_button_pressed").bind(num))
		game_area.add_child(button)
		
		buttons.append(button)
		
	$TimerGame.start()
	$ProgressBarTimer.max_value = $TimerGame.wait_time
	$ProgressBarTimer.value = $TimerGame.wait_time

func _on_button_pressed(clicked_num):
	var expected = numbers[0]
	
	if clicked_num == expected:
		for button in buttons:
			if int(button.text) == clicked_num:
				button.queue_free()
				buttons.erase(button)
				break
		numbers.pop_front()
		
		if numbers.is_empty():
			print("Você venceu!")
			emit_signal("correct_answer_hit", int(20 + 20 * State.save_data["reasoning"] * 0.05)) 
			emit_signal("game_finished", false) 
			
	else:
		print("Você perdeu!")
		emit_signal("game_finished", false) 
		
		
func get_valid_position():
	var area_size = game_area.get_size()

	var pos = Vector2()
	var tries = 0
	
	while true:
		pos.x = randf() * (area_size.x - 50)
		pos.y = randf() * (area_size.y - 50)
	
		var valid = true
		for button in buttons:
			if button.position.distance_to(pos) < 75:
				valid = false
				break
		
		if valid or tries > 30:
			break
		tries += 1
		
	return pos

func setup_timers():
	$TimerGame.wait_time = totalTime
	$TimerGame.one_shot = true
	$TimerGame.timeout.connect(_on_game_timeout)

	$TimerDisplay.wait_time = 0.1
	$TimerDisplay.one_shot = false
	$TimerDisplay.timeout.connect(_update_timer_display)
	$TimerDisplay.start()

func _update_timer_display():
	var remaining = $TimerGame.time_left
	$ProgressBarTimer/Label.text = "%.1f" % remaining
	$ProgressBarTimer.value = remaining

func _on_game_timeout():
	emit_signal("game_finished", false)
