extends Node2D

@export var card_scene: PackedScene
@export var grid_size: Vector2i = Vector2i(3, 2)
@export var item_size: Vector2 = Vector2(100, 100)
@export var padding: int = 20

var current_correct_index: int

func _ready():
	var total = grid_size.x * grid_size.y
	var different_index = randi() % total
	card_scene = load("res://scenes/game_unique_card.tscn")

	for i in range(total):
		var item = card_scene.instantiate()
		var row = i / grid_size.x
		var col = i % grid_size.x
		item.position = Vector2(col * (item_size.x + padding), row * (item_size.y + padding))

		# Define padrão
		var shape_type = "circle"
		var color = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW].pick_random()
		var count = 3

		# Se for o item diferente, muda algo
		if i == different_index:
			color = Color.RED  # exemplo de diferença

		item.set_pattern(shape_type, color, count)
		item.connect("item_clicked", Callable(self, "_on_item_clicked").bind(item))
		add_child(item)
		
	_refresh_cards()

func _on_item_clicked(card):
	var index = get_children().find(card)
	if index == current_correct_index:
		print("Acertou!")
		_refresh_cards()
	else:
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
		var item = get_child(i)
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
