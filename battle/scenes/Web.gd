extends Node2D

var layers = 4
var radius = 100.0
var points = 5

func _draw():
	for layer in range(1, layers + 1):
		var r = radius * layer / layers
		var polygon = []
		for i in range(points):
			var angle = deg_to_rad(360.0 / points * i - 90.0)
			polygon.append(Vector2(cos(angle) * r, sin(angle) * r))
		draw_polyline(polygon + [polygon[0]], Color(0.7, 0.7, 0.7))

	for i in range(points):
		var angle = deg_to_rad(360.0 / points * i - 90.0)
		var end = Vector2(cos(angle) * radius, sin(angle) * radius)
		draw_line(Vector2.ZERO, end, Color(0.5, 0.5, 0.5))
