extends Control

const TOTAL_CELLS = 25
var dots = []
var bombs = []
var trail = []
var dragging = false
var start_dot = null

func _ready():
	generate_cells()
	generate_points()
	await generate_bombs()
	show_dots()

func generate_cells():
	var grid = $Grid
	for i in range(TOTAL_CELLS):
		var cell = Button.new()
		cell.name = "Celula_%d" % i
		cell.text = ""  
		cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cell.size_flags_vertical = Control.SIZE_EXPAND_FILL
		grid.add_child(cell)
		cell.mouse_entered.connect(_on_cell_mouse_entered.bind(i))
		cell.gui_input.connect(func(event): _on_cell_gui_input(event, i))

func generate_points():
	var indices = range(TOTAL_CELLS)
		
	# Selects 2 random indices to allocate the dots
	var first = indices.pick_random()
	dots.append(first)
	indices.shuffle()
	
	var second = null
	for i in range(indices.size()):
		var possible = indices[i]
		if not is_diagonal(first, possible) and distance_between(first, possible) >= 5:
			second = possible
			indices.remove_at(i)
			break
	
	# If, for some reason, it doesn't find a possible
	if second == null and indices.size() > 0:
		second = indices.pick_random()
	
	if second != null:
		dots.append(second)

func show_dots():
	for dot in dots:
		var cell = $Grid.get_node("Celula_%d" % dot)
		cell.modulate = Color(0, 0.5, 1)

func reveal_bombs():
	for bomb in bombs:
		var cell = $Grid.get_node("Celula_%d" % bomb)
		cell.modulate = Color(1, 0, 0)
	
	await get_tree().create_timer(1.5).timeout

	for bomb in bombs:
		var cell = $Grid.get_node("Celula_%d" % bomb)
		cell.modulate = Color(1, 1, 1)

func generate_bombs():
	var indices = []
	for i in range(TOTAL_CELLS):
		indices.append(i)
		
	# Erases the chance of a bomb generatin in the same place of a dot
	for dot in dots:
		indices.erase(dot)
		
	bombs.clear()
		
	# Generates 6 bombs
	while true:
		var possible = indices.duplicate()
		var temp_bombs = []

		for i in range(6):
			if possible.size() == 0:
				break
			var bomb_index = possible.pick_random()
			temp_bombs.append(bomb_index)
			possible.erase(bomb_index)
			
		bombs = temp_bombs
		if is_path_possible(dots[0], dots[1]):
			break
		
	await reveal_bombs()

func add_to_trail(index):
	trail.append(index)
	var cell = $Grid.get_node("Celula_%d" % index)
	if dots.has(index):
		cell.modulate = Color(0, 0.5, 1)
	#elif bombs.has(index):
		#cell.modulate = Color(1, 1, 1)
	else:
		cell.modulate = Color(0, 1, 0)

func reset_trail():
	for i in range(TOTAL_CELLS):
		if not dots.has(i):
			var cell = $Grid.get_node("Celula_%d" % i)
			cell.modulate = Color(1, 1, 1)
	dragging = false
	start_dot = null
	trail.clear()

func is_path_possible(start, goal):
	var visited = []
	var queue = [start]

	while queue.size() > 0:
		var current = queue.pop_front()
		if current == goal:
			return true
		if visited.has(current):
			continue
		visited.append(current)
		
		var x = current % 5
		var y = current / 5
		var neighbors = []
		
		if x > 0: neighbors.append(current - 1)
		if x < 4: neighbors.append(current + 1)
		if y > 0: neighbors.append(current - 5)
		if y < 4: neighbors.append(current + 5)
		
		for n in neighbors:
			if not visited.has(n) and not bombs.has(n):
				queue.append(n)
	return false

func is_adjacent(a, b):
	var ax = a % 5
	var ay = a / 5
	var bx = b % 5
	var by = b / 5
	
	var dx = abs(ax - bx)
	var dy = abs(ay - by)
	
	return (dx == 1 and dy == 0) or (dx == 0 and dy == 1)

func is_diagonal(a, b):
	var ax = a % 5
	var ay = a / 5
	var bx = b % 5
	var by = b / 5

	return abs(ax - bx) == abs(ay - by) and a != b

# Manhattan distance 
func distance_between(a, b):
	var ax = a % 5
	var ay = a / 5
	var bx = b % 5
	var by = b / 5

	return abs(ax - bx) + abs(ay - by) 

func _on_cell_mouse_entered(index):
	if dragging:
		if not trail.has(index) and is_adjacent(trail[-1], index):
			add_to_trail(index)
			
			if dots.has(index) and index != start_dot:
				dragging = false  
				var has_bomb = false
				for i in trail:
					if bombs.has(i):
						has_bomb = true
						break
				
				if has_bomb:
					print("Você perdeu! A trilha passou por uma bomba.")
					await reveal_bombs()
				else:
					print("Pontos conectados com sucesso!")
					await get_tree().create_timer(1.0).timeout
					
				reset_trail()

func _on_cell_gui_input(event, index):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if dots.has(index):
					dragging = true
					start_dot = index
					trail.clear()
					add_to_trail(index)
			else:
				if dragging:
					print("Arrasto interrompido.")
					reset_trail()
