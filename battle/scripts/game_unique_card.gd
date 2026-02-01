extends Control

signal item_clicked

var shape_type: String = "circle"
var color: Color = Color.WHITE
var count: int = 1

func _ready():
	set_custom_minimum_size(Vector2(100, 100))

func set_pattern(shape_type_: String, color_: Color, count_: int):
	shape_type = shape_type_
	color = color_
	count = count_
	queue_redraw()

func _draw():
	# fundo e borda
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.9,0.9,0.9,1.0))
	draw_rect(Rect2(Vector2.ZERO, size), Color.BLACK, false, 2)

	var cols = 2
	var rows = ceil(float(count) / cols)

	var cell_w = size.x / cols
	var cell_h = size.y / rows

	for i in range(count):
		var row = i / cols
		var col = i % cols

		var pos: Vector2
		if row == rows - 1 and count % cols == 1 and col == 0:
			pos = Vector2(size.x/2, row * cell_h + cell_h/2)
		else:
			pos = Vector2(col * cell_w + cell_w/2, row * cell_h + cell_h/2)

		match shape_type:
			"circle":
				var radius = min(cell_w, cell_h) * 0.25
				draw_circle(pos, radius, color)
			"square":
				var side = min(cell_w, cell_h) * 0.5
				draw_rect(Rect2(pos - Vector2(side/2, side/2), Vector2(side, side)), color)
			"triangle":
				var size_t = min(cell_w, cell_h) * 0.5
				var points = [
					pos + Vector2(0, -size_t/2),
					pos + Vector2(-size_t/2, size_t/2),
					pos + Vector2(size_t/2, size_t/2)
				]
				draw_polygon(points, [color])

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("item_clicked")
