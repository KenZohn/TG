extends Control

signal correct_answer_hit(damage)
signal wrong_answer()
signal game_finished()
signal timer_update(time)

var figuras = []
var posicoes = []
var figuras_alvo = []
var pontuacao = 0

var quantidade_cartas = 4
var cartas = []
var reveladas = []
var damage = 4

@onready var grid = $ColorRect/CenterContainer/VBoxContainer/MarginContainer/GridContainer
@onready var alvo_container = $ColorRect/CenterContainer/VBoxContainer/HBoxContainer

@onready var timer = $Timer
@onready var timer_game = $TimerGame
@onready var timer_display = $TimerDisplay
@onready var timer_interval = $TimerInterval

func _ready():
	randomize()
	setup_timers()
	
	carregar_figuras()
	criar_cartas(quantidade_cartas)
	distribuir_figuras()

	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start(3.0)

	timer_game.start()
	timer_display.timeout.connect(_update_timer_display)

# =========================
# FIGURAS
# =========================
func carregar_figuras():
	figuras = [
		preload("res://assets/figures/circle.png"),
		preload("res://assets/figures/cross.png"),
		preload("res://assets/figures/square.png"),
		preload("res://assets/figures/triangle.png"),
		preload("res://assets/figures/pause.png")
	]

# =========================
# CARTAS
# =========================
func criar_cartas(qtd: int):
	cartas.clear()
	reveladas.clear()

	grid.columns = 2  # automático

	for i in range(qtd):
		var carta = Button.new()
		carta.custom_minimum_size = Vector2(80, 80)
		carta.icon = null
		carta.disabled = true
		carta.expand_icon = true

		grid.add_child(carta)
		cartas.append(carta)
		reveladas.append(false)

		carta.pressed.connect(_on_carta_pressed.bind(carta))

# =========================
# DISTRIBUIÇÃO
# =========================
func distribuir_figuras():
	posicoes.clear()

	var figuras_embaralhadas = figuras.duplicate()
	figuras_embaralhadas.shuffle()

	for i in range(cartas.size()):
		var figura = figuras_embaralhadas[i % figuras_embaralhadas.size()]
		cartas[i].icon = figura
		posicoes.append(figura)
		cartas[i].disabled = true

# =========================
# MEMORIZAÇÃO → JOGO
# =========================
func _on_timer_timeout():
	# esconder cartas
	for i in range(cartas.size()):
		cartas[i].icon = null
		cartas[i].disabled = false
		reveladas[i] = false

	# escolher alvos
	var posicoes_embaralhadas = posicoes.duplicate()
	posicoes_embaralhadas.shuffle()

	figuras_alvo.clear()

	for i in range(min(2, posicoes_embaralhadas.size())):
		figuras_alvo.append(posicoes_embaralhadas[i])

	# limpar alvos antigos
	for child in alvo_container.get_children():
		child.queue_free()

	# criar alvos
	for figura in figuras_alvo:
		var alvo = TextureRect.new()
		alvo.texture = figura
		alvo.custom_minimum_size = Vector2(64, 64)

		alvo.expand = true
		alvo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		alvo.custom_minimum_size = Vector2(64, 64)
		alvo_container.add_child(alvo)
		alvo_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		alvo_container.alignment = BoxContainer.ALIGNMENT_CENTER

# =========================
# INPUT
# =========================
func _on_carta_pressed(carta: Button):
	var index = cartas.find(carta)
	verificar_escolha(index)

# =========================
# LÓGICA
# =========================
func verificar_escolha(index):
	var figura_correta = posicoes[index]

	if figura_correta in figuras_alvo:
		cartas[index].icon = figura_correta
		reveladas[index] = true
		cartas[index].disabled = true

		pontuacao += 1
		figuras_alvo.erase(figura_correta)

		emit_signal("correct_answer_hit", damage)

		if figuras_alvo.is_empty():
			reiniciar_jogo()

	else:
		cartas[index].modulate = Color(1, 0.3, 0.3)
		cartas[index].disabled = true

		await get_tree().create_timer(0.3).timeout
		cartas[index].modulate = Color(1, 1, 1)

		emit_signal("wrong_answer")
		_apply_time_penalty()

# =========================
# RESET
# =========================
func reiniciar_jogo():
	posicoes.clear()
	figuras_alvo.clear()
	reveladas.clear()

	for child in alvo_container.get_children():
		child.queue_free()

	for i in range(cartas.size()):
		cartas[i].icon = null
		cartas[i].disabled = true
		reveladas.append(false)

	distribuir_figuras()
	timer.start(3.0)

# =========================
# TEMPO
# =========================
func _apply_time_penalty():
	var remaining = timer_game.time_left
	var new_time = max(remaining - 2.0, 0.1)

	timer_game.stop()
	timer_game.wait_time = new_time
	timer_game.start()

func setup_timers():
	timer_game.wait_time = State.time
	timer_game.one_shot = true
	timer_game.timeout.connect(_on_game_timeout)

	timer_interval.wait_time = 0.1
	timer_interval.one_shot = true
	timer_interval.timeout.connect(_on_interval_timeout)

	timer_display.wait_time = 0.1
	timer_display.one_shot = false
	timer_display.start()

func _update_timer_display():
	emit_signal("timer_update", timer_game.time_left)

func _on_interval_timeout():
	if timer_game.is_stopped():
		return

func _on_game_timeout():
	timer_interval.stop()
	emit_signal("game_finished")
