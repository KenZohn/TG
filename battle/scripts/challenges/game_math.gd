extends Control

signal correct_answer_hit(damage)
signal wrong_answer()
signal game_finished()
signal timer_update(time)

enum Operation {
	PLUS,    
	MINUS,   
	MULTIPLY, 
	DIVIDE   
}

@onready var equation_label = $ContainerCard/Equation

var num1: int
var num2: int
var result: int
var correct_operation: Operation
var damage = 5

func _ready():
	setup_timers()
	generate_equation()
	start_timer()

func generate_equation():
	# Gera operação aleatória
	correct_operation = randi() % 4
	
	match correct_operation:
		Operation.PLUS:
			num1 = randi_range(1, 20)
			num2 = randi_range(1, 20)
			result = num1 + num2
		
		Operation.MINUS:
			result = randi_range(1, 20)
			num2 = randi_range(1, result)
			num1 = result + num2
		
		Operation.MULTIPLY:
			num1 = randi_range(2, 10)
			num2 = randi_range(2, 10)
			result = num1 * num2
		
		Operation.DIVIDE:
			num2 = randi_range(2, 10)
			result = randi_range(2, 10)
			num1 = result * num2
	
	equation_label.text = "%d ? %d = %d" % [num1, num2, result]

func _on_button_pressed(operation: int):
	if operation == correct_operation:
		print("Acertou!")
		emit_signal("correct_answer_hit", damage)
	else:
		print("Errou!")
		emit_signal("wrong_answer")
		_apply_time_penalty()
	
	# Gera nova equação
	await get_tree().create_timer(0.5).timeout
	generate_equation()

# Timers
func start_timer():
	$TimerGame.start()

func setup_timers():
	$TimerGame.wait_time = State.time
	$TimerGame.one_shot = true
	$TimerGame.timeout.connect(_on_game_timeout)
	
	$TimerDisplay.wait_time = 0.1
	$TimerDisplay.one_shot = false
	$TimerDisplay.timeout.connect(_update_timer_display)
	$TimerDisplay.start()

func _update_timer_display():
	var remaining = $TimerGame.time_left
	emit_signal("timer_update", remaining)

func _on_game_timeout():
	emit_signal("game_finished")

func _apply_time_penalty():
	var remaining = $TimerGame.time_left
	var new_time = max(remaining - 2.0, 0.1)
	$TimerGame.stop()
	$TimerGame.wait_time = new_time
	$TimerGame.start()
