extends Control

signal game_finished(result)

var tempo_inicio: float = 0.0
var tempo_reacao: float = 0.0
var pronto_para_reagir: bool = false

func _ready():
	$LabelMensagem.text = ""
	$TimerEspera.wait_time = randf_range(3.0, 7.0) # tempo aleatório
	$TimerEspera.timeout.connect(_on_TimerEspera_timeout)
	$TimerEspera.start()
	
func _on_TimerEspera_timeout():
	$LabelMensagem.text = "AGORA!"
	$AudioStreamPlayer.play()
	pronto_para_reagir = true
	tempo_inicio = Time.get_ticks_msec() / 1000.0

func _on_botao_reagir_pressed():
	if pronto_para_reagir:
		tempo_reacao = (Time.get_ticks_msec() / 1000.0) - tempo_inicio
		$LabelMensagem.text = "%.3f segundos" % tempo_reacao
		pronto_para_reagir = false
		emit_signal("game_finished", true) # Resultado retornado
	else:
		$LabelMensagem.text = "Adiantado"
		emit_signal("game_finished", false) # Resultado retornado
