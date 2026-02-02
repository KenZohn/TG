extends Node2D

signal correct_answer_hit(damages)
signal wrong_answer()
signal game_finished()
signal timer_update(time)

@export var card_scene: PackedScene
@export var grid_size: Vector2i = Vector2i(3, 2)
@export var item_size: Vector2 = Vector2(100, 100)
@export var padding: int = 20

@onready var game_timer = $TimerGame
@onready var interval_timer = $TimerInterval
@onready var display_timer = $TimerDisplay

var current_correct_index: int

var damage = 3
var awaiting_response: bool = false

func _ready():
	setup_timers()
	start_timer()
	display_timer.timeout.connect(_update_timer_display)
	
	card_scene = load("res://scenes/game_unique_card.tscn")
	
	# Container config
	var viewport_size = get_viewport_rect().size
	var target_area = Vector2(370, 310)

	# Centraliza na horizontal
	var offset_x = (viewport_size.x - target_area.x) / 2

	# Posiciona 35 px acima da borda inferior
	var offset_y = viewport_size.y - target_area.y - 35

	$CardsContainer.position = Vector2(offset_x, offset_y)
	
	# cria os cards só uma vez
	_create_cards()
	
	# aplica padrões iniciais
	_refresh_cards()

func _on_item_clicked(card):
	var index = $CardsContainer/Cards.get_children().find(card)
	if index == current_correct_index:
		emit_signal("correct_answer_hit", damage)
		print("Acertou!")
		_refresh_cards()
	else:
		emit_signal("wrong_answer")
		_apply_time_penalty()
		print("Errou!")

func _refresh_cards():
	var total = grid_size.x * grid_size.y
	
	# Padrão base
	var base_shape = ["circle", "square", "triangle"].pick_random()
	var base_color = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW].pick_random()
	var base_count = randi_range(2, 4)
	
	# Índice do card único
	current_correct_index = randi() % total
	
	# Sorteia qual categoria será diferente nesta rodada
	var difference_type = ["shape", "color", "count"].pick_random()
	
	for i in range(total):
		var item = $CardsContainer/Cards.get_child(i)
		var shape_type = base_shape
		var color = base_color
		var count = base_count
		
		if i == current_correct_index:
			match difference_type:
				"shape":
					var other_shapes = ["circle", "square", "triangle"]
					other_shapes.erase(base_shape)
					shape_type = other_shapes.pick_random()
				"color":
					var other_colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW]
					other_colors.erase(base_color)
					color = other_colors.pick_random()
				"count":
					var other_count = base_count
					while other_count == base_count:
						other_count = randi_range(1, 4)
					count = other_count
		else:
			if difference_type == "count" and randf() < 0.3:
				count = base_count # mantém igual, evita criar outro único
		
		item.set_pattern(shape_type, color, count)

func _create_cards():
	var total = grid_size.x * grid_size.y
	
	# calcula tamanho total da grade
	var grid_width = grid_size.x * item_size.x + (grid_size.x - 1) * padding
	var grid_height = grid_size.y * item_size.y + (grid_size.y - 1) * padding
	
	# calcula offset para centralizar dentro do fundo 380x310
	var offset_x = (380 - grid_width) / 2
	var offset_y = (310 - grid_height) / 2
	
	for i in range(total):
		var item = card_scene.instantiate()
		var row = i / grid_size.x
		var col = i % grid_size.x
		
		var pos_x = offset_x + col * (item_size.x + padding)
		var pos_y = offset_y + row * (item_size.y + padding)
		
		item.position = Vector2(pos_x, pos_y)
		item.connect("item_clicked", Callable(self, "_on_item_clicked").bind(item))
		$CardsContainer/Cards.add_child(item)

func start_timer():
	game_timer.start()
	game_timer.timeout.connect(_on_game_timeout)

func _update_timer_display():
	var remaining = game_timer.time_left
	emit_signal("timer_update", remaining)

func setup_timers():
	game_timer.wait_time = State.time
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_game_timeout)
	
	interval_timer.wait_time = 0.1
	interval_timer.one_shot = true
	interval_timer.timeout.connect(_on_interval_timeout)
	
	display_timer.wait_time = 0.1
	display_timer.one_shot = false
	display_timer.start()

func _on_interval_timeout():
	if game_timer.is_stopped():
		return

func _on_game_timeout():
	interval_timer.stop()
	awaiting_response = false
	
	emit_signal("game_finished")

func _apply_time_penalty():
	var remaining = game_timer.time_left
	var new_time = max(remaining - 2.0, 0.1)
	game_timer.stop()
	game_timer.wait_time = new_time
	game_timer.start()
