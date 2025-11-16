extends Control

signal correct_answer_hit(damage)
signal game_finished(result)

var start_time: float = 0.0
var reaction_time: float = 0.0
var ready_to_react: bool = false

var totalTime = 15.0 + State.save_data["agility"] * 0.05

func _ready():
	$ProgressBarTimer/Label.text = "%.1f" % totalTime
	$Panel/LabelMensage.text = ""
	$WaitTimer.wait_time = randf_range(2.0, 6.0) # Intervalo de tempo aleatório
	$WaitTimer.timeout.connect(_on_WaitTimer_timeout)
	$WaitTimer.start()
	
func _on_WaitTimer_timeout():
	$Panel/LabelMensage.text = "AGORA!"
	$AudioStreamPlayer.play()
	ready_to_react = true
	start_time = Time.get_ticks_msec() / 1000.0

func _on_react_button_pressed():
	if ready_to_react:
		$Panel/ReactButton.disabled = true
		reaction_time = (Time.get_ticks_msec() / 1000.0) - start_time
		$Panel/LabelMensage.text = "%.3f segundos" % reaction_time
		ready_to_react = false
		emit_signal("correct_answer_hit", int(30 + 30 * State.save_data["focus"] * 0.05)) # Cada acerto causa 30 de dano
		emit_signal("game_finished", true) # Resultado retornado
	else:
		$Panel/ReactButton.disabled = true
		$Panel/LabelMensage.text = "Adiantado"
		emit_signal("game_finished", false) # Resultado retornado
