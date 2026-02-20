extends Node2D

var figuras = []
var posicoes = []
var figuras_alvo = []
var pontuacao = 0

var quantidade_cartas = 4
var cartas = []
var reveladas = []  # lista paralela a 'cartas'

@onready var alvo_container = $AlvoContainer
@onready var timer = $Timer

func _ready():
	randomize()
	carregar_figuras()
	criar_cartas(quantidade_cartas)
	distribuir_figuras()
	timer.one_shot = true   # dispara apenas uma vez
	timer.start(3.0)

func carregar_figuras():
	figuras = [
		preload("res://assets/figures/circle.png"),
		preload("res://assets/figures/cross.png"),
		preload("res://assets/figures/square.png"),
		preload("res://assets/figures/triangle.png"),
		preload("res://assets/figures/pause.png")
	]

func criar_cartas(qtd: int):
	reveladas.clear()
	for i in range(qtd):
		var carta = Button.new()
		carta.text = ""
		carta.custom_minimum_size = Vector2(64, 64)
		carta.icon = null   # carta virada para baixo, sem figura

		var x = (i % 2) * (64 + 16)
		var y = int(i / 2) * (64 + 16)
		carta.position = Vector2(x, y)

		add_child(carta)
		cartas.append(carta)
		reveladas.append(false)  # começa como não revelada
		carta.connect("pressed", Callable(self, "_on_carta_pressed").bind(carta))

func distribuir_figuras():
	posicoes.clear()
	var figuras_embaralhadas = figuras.duplicate()
	figuras_embaralhadas.shuffle()

	for i in range(cartas.size()):
		var figura = figuras_embaralhadas[i % figuras_embaralhadas.size()]
		cartas[i].icon = redimensionar_textura(figura, Vector2(64,64))
		cartas[i].disabled = true   # bloqueia clique durante memorização
		posicoes.append(figura)

func _on_timer_timeout() -> void:
	# Oculta todas as cartas e ativa para clique
	for i in range(cartas.size()):
		cartas[i].icon = null
		cartas[i].disabled = false
		reveladas[i] = false

	# Escolhe figuras-alvo
	var posicoes_embaralhadas = posicoes.duplicate()
	posicoes_embaralhadas.shuffle()

	figuras_alvo.clear()
	var quantidade = 2
	for i in range(min(quantidade, posicoes_embaralhadas.size())):
		figuras_alvo.append(posicoes_embaralhadas[i])

	# Remove alvos antigos
	for child in get_children():
		if child is Button and child.name.begins_with("Alvo"):
			remove_child(child)
			child.queue_free()

	# Calcula altura total ocupada pelas cartas
	var largura = 64
	var altura = 64
	var margem = 16
	var colunas = 2
	var linhas = int(ceil(float(cartas.size()) / colunas))
	var altura_cartas = linhas * (altura + margem)

	# Cria botões de alvos logo abaixo das cartas
	for i in range(figuras_alvo.size()):
		var alvo = Button.new()
		alvo.name = "Alvo" + str(i)
		alvo.text = ""
		alvo.custom_minimum_size = Vector2(largura, altura)
		alvo.icon = redimensionar_textura(figuras_alvo[i], Vector2(largura, altura))

		# posiciona em linha abaixo das cartas
		var x = i * (largura + margem)
		var y = altura_cartas + margem
		alvo.position = Vector2(x, y)

		add_child(alvo)

	print("Encontre as figuras:", figuras_alvo)

func _on_carta_pressed(carta: Button):
	var index = cartas.find(carta)

	verificar_escolha(index)

	carta.disabled = true

func verificar_escolha(index):
	var figura_correta = posicoes[index]
	if figura_correta in figuras_alvo:
		cartas[index].icon = redimensionar_textura(figura_correta, Vector2(64,64))
		reveladas[index] = true
		cartas[index].disabled = true   # não pode mais clicar
		pontuacao += 1
		figuras_alvo.erase(figura_correta)
		print("Acertou! Pontos:", pontuacao)

		if figuras_alvo.is_empty():
			reiniciar_jogo()
	else:
		cartas[index].modulate = Color(1, 0, 0)
		cartas[index].disabled = true   # errou, também não pode clicar de novo
		print("Errou!")

func redimensionar_textura(tex: Texture, tamanho: Vector2) -> Texture:
	var img = tex.get_image()
	img.resize(tamanho.x, tamanho.y)
	return ImageTexture.create_from_image(img)  # chamada correta

func reiniciar_jogo():
	print("Todas as figuras encontradas! Reiniciando...")
	pontuacao = 0
	posicoes.clear()
	figuras_alvo.clear()
	reveladas.clear()

	# Remove alvos antigos
	for child in get_children():
		if child is Button and child.name.begins_with("Alvo"):
			remove_child(child)
			child.queue_free()

	# Reseta cartas
	for i in range(cartas.size()):
		var carta = cartas[i]
		carta.icon = null
		carta.modulate = Color(1,1,1)
		carta.disabled = true   # ficam bloqueadas até o timer liberar
		reveladas.append(false)

	distribuir_figuras()
	timer.start(3.0)
