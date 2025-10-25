extends Control

signal correct_answer_hit(damage)
signal game_finished(score)

var todas_imagens = ["circle", "square", "triangle", "cross"]
var imagens_esquerda = []
var imagens_direita = []
var fila_imagens = []
var imagem_atual_index = 0

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
	iniciar_temporizador()
	botao_esquerda.pressed.connect(func(): verificar_resposta("esquerda"))
	botao_direita.pressed.connect(func(): verificar_resposta("direita"))

func mostrar_imagem_atual():
	var nome = fila_imagens[imagem_atual_index]
	imagem_central.texture = load("res://assets/figures/%s.png" % nome)

func verificar_resposta(lado_escolhido):
	var nome = fila_imagens[imagem_atual_index]
	var lado_correto = "esquerda" if imagens_esquerda.has(nome) else "direita"

	if lado_escolhido == lado_correto:
		label_feedback.text = "✅ Correto!"
		emit_signal("correct_answer_hit", int(2 + 2 * State.save_data["focus"] * 0.05))
	else:
		label_feedback.text = "❌ Errado!"

	imagem_atual_index += 1
	if imagem_atual_index < fila_imagens.size():
		mostrar_imagem_atual()
	else:
		label_feedback.text += "\nFim do jogo!"
		botao_esquerda.disabled = true
		botao_direita.disabled = true
		emit_signal("game_finished", false)

func iniciar_temporizador():
	timer_jogo.start()
	timer_jogo.timeout.connect(finalizar_jogo)

func finalizar_jogo():
	label_feedback.text = "⏰ Tempo esgotado!\nFim do jogo!"
	botao_esquerda.disabled = true
	botao_direita.disabled = true
	emit_signal("game_finished", false)
