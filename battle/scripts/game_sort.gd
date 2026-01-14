extends Control

signal correct_answer_hit(damage)
signal wrong_answer()
signal game_finished()

var todas_imagens = ["circle", "square", "triangle", "cross"]
var imagens_esquerda = []
var imagens_direita = []
var fila_imagens = []
var imagem_atual_index = 0
var damage = 2

var awaiting_response: bool = false

@onready var figure_left_1 = $ContainerCard/FigureLeft1
@onready var figure_left_2 = $ContainerCard/FigureLeft2
@onready var figure_right_1 = $ContainerCard/FigureRight1
@onready var figure_right_2 = $ContainerCard/FigureRight2
@onready var imagem_central = $ContainerCard/FigureMiddle
@onready var botao_esquerda = $ContainerCard/ButtonLeft
@onready var botao_direita = $ContainerCard/ButtonRight
@onready var label_feedback = $ContainerCard/Label
@onready var timer_jogo = $TimerGame

func _ready():
	$ProgressBarTimer/Label.text = "%.1f" % State.time
	
	randomize()

	var imagens_embaralhadas = todas_imagens.duplicate()
	imagens_embaralhadas.shuffle()

	imagens_esquerda = imagens_embaralhadas.slice(0, 2)
	imagens_direita = imagens_embaralhadas.slice(2, 4)
	
	figure_left_1.texture = load("res://assets/figures/%s.png" % imagens_esquerda[0])
	figure_left_2.texture = load("res://assets/figures/%s.png" % imagens_esquerda[1])

	figure_right_1.texture = load("res://assets/figures/%s.png" % imagens_direita[0])
	figure_right_2.texture = load("res://assets/figures/%s.png" % imagens_direita[1])

	# Junta todas e embaralha para criar a fila
	var todas_selecionadas = imagens_esquerda + imagens_direita
	for i in range(30):  # número alto para durar 15s
		fila_imagens.append(todas_selecionadas.pick_random())

	# Inicia o jogo
	mostrar_imagem_atual()
	setup_timers()
	iniciar_temporizador()
	$TimerDisplay.timeout.connect(_update_timer_display)
	
	botao_esquerda.pressed.connect(func(): verificar_resposta("esquerda"))
	botao_direita.pressed.connect(func(): verificar_resposta("direita"))

func mostrar_imagem_atual():
	var nome = fila_imagens[imagem_atual_index]
	imagem_central.texture = load("res://assets/figures/%s.png" % nome)

func verificar_resposta(lado_escolhido):
	var nome = fila_imagens[imagem_atual_index]
	var lado_correto = "esquerda" if imagens_esquerda.has(nome) else "direita"
	
	if lado_escolhido == lado_correto:
		label_feedback.text = "Correto!"
		emit_signal("correct_answer_hit", damage)
	else:
		label_feedback.text = "Errado!"
		_apply_time_penalty()
		emit_signal("wrong_answer")
	
	imagem_atual_index += 1
	if imagem_atual_index < fila_imagens.size():
		mostrar_imagem_atual()
	else:
		botao_esquerda.disabled = true
		botao_direita.disabled = true
		emit_signal("game_finished")

func iniciar_temporizador():
	timer_jogo.start()
	$ProgressBarTimer.max_value = $TimerGame.wait_time
	$ProgressBarTimer.value = $TimerGame.wait_time
	timer_jogo.timeout.connect(_on_game_timeout)

func _update_timer_display():
	var remaining = $TimerGame.time_left
	$ProgressBarTimer/Label.text = "%.1f" % remaining
	$ProgressBarTimer.value = remaining

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

func _on_interval_timeout():
	if $TimerGame.is_stopped():
		return

func _on_game_timeout():
	$TimerInterval.stop()
	awaiting_response = false
	
	botao_esquerda.disabled = true
	botao_direita.disabled = true
	
	emit_signal("game_finished")

func _apply_time_penalty():
	var remaining = $TimerGame.time_left
	var new_time = max(remaining - 2.0, 0.1) # Evita tempo zero ou negativo
	$TimerGame.stop()
	$TimerGame.wait_time = new_time
	$TimerGame.start()
