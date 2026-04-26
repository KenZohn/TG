extends Control

@onready var speaker_label = $DialogBox/MarginContainer/VBoxContainer/Speaker
@onready var text_label = $DialogBox/MarginContainer/VBoxContainer/Text
@onready var left_character = $LeftCharacter
@onready var right_character = $RightCharacter
@onready var timer = $Timer

@export var dialog_file: String = ""  # Caminho pro JSON de diálogos

var dialogs = []
var current_dialog = 0
var current_char = 0
var is_typing = false
var can_advance = false

func _ready():
	if dialog_file.is_empty():
		load_default_dialogs()
	else:
		load_dialogs_from_file()
	
	show_dialog(0)
	timer.timeout.connect(_on_timer_timeout)
	# Adicionar uma musga depois

func load_default_dialogs():
	dialogs = [
		{
			"speaker": "Protagonista",
			"text": "Onde... onde estou?",
			"side": "left"
		},
		{
			"speaker": "Gugu",
			"text": "Ah, você acordou! Bem-vindo, jovem!",
			"side": "right"
		},
		{
			"speaker": "Protagonista",
			"text": "Quem é você? O que aconteceu?",
			"side": "left"
		},
		{
			"speaker": "Gugu",
			"text": "Sou Gugu! Você desmaiou... estava muito tempo no celular, não é?",
			"side": "right"
		},
		{
			"speaker": "Protagonista",
			"text": "Eu... acho que sim. Mas que lugar é este?",
			"side": "left"
		},
		{
			"speaker": "Gugu",
			"text": "Este é um mundo especial. Aqui, sua mente é testada!",
			"side": "right"
		},
		{
			"speaker": "Gugu",
			"text": "Para voltar para casa, você precisa enfrentar desafios cognitivos.",
			"side": "right"
		},
		{
			"speaker": "Protagonista",
			"text": "Desafios... cognitivos?",
			"side": "left"
		},
		{
			"speaker": "Gugu",
			"text": "Sim! Memória, raciocínio, agilidade mental... Use seu cérebro!",
			"side": "right"
		},
		{
			"speaker": "Gugu",
			"text": "Derrote os inimigos resolvendo quebra-cabeças e você voltará para casa!",
			"side": "right"
		},
		{
			"speaker": "Protagonista",
			"text": "Entendi... Vou dar o meu melhor!",
			"side": "left"
		}
	]

func load_dialogs_from_file():
	if not FileAccess.file_exists(dialog_file):
		print("Arquivo de diálogo não encontrado: ", dialog_file)
		load_default_dialogs()
		return
	
	var file = FileAccess.open(dialog_file, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var result = json.parse(json_string)
	if result == OK:
		dialogs = json.data
	else:
		print("Erro ao ler JSON de diálogo")
		load_default_dialogs()

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		if is_typing:
			complete_text()
		elif can_advance:
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
	
	update_characters(dialog.get("side", "left"))
	
	timer.start()

# Destaca quem está falando
func update_characters(active_side: String):
	if active_side == "left":
		left_character.modulate = Color(1, 1, 1, 1) 
		right_character.modulate = Color(0.5, 0.5, 0.5, 0.7)
	else:
		left_character.modulate = Color(0.5, 0.5, 0.5, 0.7)
		right_character.modulate = Color(1, 1, 1, 1)

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
