extends Node2D

signal sudoku_finished(result)

@onready var grid:GridContainer = $GridContainer
@onready var feedback_label:Label = $FeedbackLabel
@onready var select_grid:Node = $SelectGrid

var puzzle = []
var missing_number = 0
var empty_button:Button

func _ready():
	grid.columns = 3
	generate_puzzle()
	populate_grid()
	bind_selectgrid_button_actions()

func generate_puzzle():
	var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	numbers.shuffle()
	missing_number = numbers.pop_back() # remove um número aleatório
	puzzle = numbers

func populate_grid():
	var empty_index = randi_range(0, 8)
	var filled_numbers = puzzle.duplicate()
	filled_numbers.insert(empty_index, 0) # insere espaço vazio

	for i in range(9):
		var button = Button.new()
		button.custom_minimum_size = Vector2(80, 80)
		button.set("theme_override_font_sizes/font_size", 32)

		if i == empty_index:
			button.text = ""
			empty_button = button
		else:
			button.text = str(filled_numbers[i])
			button.disabled = true

		grid.add_child(button)

func bind_selectgrid_button_actions():
	for button in select_grid.get_children():
		var b = button as Button
		b.pressed.connect(_on_selectgrid_button_pressed.bind(int(b.text)))

func _on_selectgrid_button_pressed(number_pressed):
	disable_buttons()
	if empty_button == null:
		return
	
	# Sempre exibe o número escolhido
	empty_button.text = str(number_pressed)
	
	if number_pressed == missing_number:
		empty_button.disabled = true
		feedback_label.text = "✅ Correto! O número faltante era " + str(number_pressed)
		highlight_button(Color.SEA_GREEN)
		emit_signal("sudoku_finished", true) # Resultado retornado
	else:
		feedback_label.text = "❌ Tente novamente. Esse número já está presente."
		highlight_button(Color.DARK_RED)
		emit_signal("sudoku_finished", false) # Resultado retornado


func highlight_button(color:Color):
	var stylebox := StyleBoxFlat.new()
	stylebox.bg_color = color
	stylebox.set_border_width_all(2)
	stylebox.border_color = Color.BLACK
	empty_button.add_theme_stylebox_override("normal", stylebox)
	empty_button.add_theme_stylebox_override("disabled", stylebox)

func disable_buttons():
	for button in select_grid.get_children():
		if button is Button:
			button.disabled = true
