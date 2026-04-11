extends Control

@onready var speaker_label = $DialogBox/MarginContainer/VBoxContainer/Speaker
@onready var text_label = $DialogBox/MarginContainer/VBoxContainer/Text
@onready var timer = $Timer

var dialogs = [
	{
		"speaker": "Narrador",
		"text": "Em um mundo onde a mente é a arma mais poderosa..."
	},
	{
		"speaker": "Narrador",
		"text": "Você desperta com habilidades cognitivas especiais."
	},
	{
		"speaker": "Narrador",
		"text": "Memória, Agilidade, Foco, Raciocínio e Coordenação..."
	},
	{
		"speaker": "Narrador",
		"text": "Esses são os atributos que definirão seu destino."
	},
	{
		"speaker": "Você",
		"text": "Onde estou? O que aconteceu?"
	},
	{
		"speaker": "Narrador",
		"text": "Para sobreviver, você precisará treinar sua mente..."
	},
	{
		"speaker": "Narrador",
		"text": "Enfrente os desafios, derrote os inimigos, e descubra a verdade!"
	}
]

var current_dialog = 0
var current_char = 0
var is_typing = false
var can_advance = false

func _ready():
	show_dialog(0)
	timer.timeout.connect(_on_timer_timeout)
	# Adicionar uma musga depois

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		if is_typing:
			# Pula a digitação e mostra tudo
			complete_text()
		elif can_advance:
			# Avança para próximo diálogo
			next_dialog()

func show_dialog(index: int):
	if index >= dialogs.size():
		finish_cutscene()
		return
	
	current_dialog = index
	current_char = 0
	can_advance = false
	is_typing = true
	
	var dialog = dialogs[index]
	speaker_label.text = dialog.speaker
	text_label.text = ""
	
	timer.start()

func _on_timer_timeout():
	if not is_typing:
		return
	
	var dialog = dialogs[current_dialog]
	var full_text = dialog.text
	
	if current_char < full_text.length():
		text_label.text += full_text[current_char]
		current_char += 1
	else:
		# Terminou de digitar
		is_typing = false
		can_advance = true
		timer.stop()

func complete_text():
	var dialog = dialogs[current_dialog]
	text_label.text = dialog.text
	current_char = dialog.text.length()
	is_typing = false
	can_advance = true
	timer.stop()

func next_dialog():
	show_dialog(current_dialog + 1)

func finish_cutscene():
	State.is_new_game = false
	
	await get_tree().create_timer(0.5).timeout
	FadeLayer.fade_to_scene("res://scenes/game/map.tscn")
