@tool
extends Node2D

@export var layers := 4
@export var radius := 100.0
@export var points := 5

func _ready():
	queue_redraw()

func _draw():
	for layer in range(1, layers + 1):
		var r = radius * layer / layers
		var polygon = []
		for i in range(points):
			var angle = deg_to_rad(360.0 / points * i - 90.0)
			polygon.append(Vector2(cos(angle) * r, sin(angle) * r))
		if polygon.size() > 0:
			draw_polyline(polygon + [polygon[0]], Color(0.7, 0.7, 0.7))

	for i in range(points):
		var angle = deg_to_rad(360.0 / points * i - 90.0)
		var end = Vector2(cos(angle) * radius, sin(angle) * radius)
		draw_line(Vector2.ZERO, end, Color(0.5, 0.5, 0.5))
