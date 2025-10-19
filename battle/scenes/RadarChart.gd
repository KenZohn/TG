extends Node2D

var values = [State.save_data["memory"]/30,
			  State.save_data["agility"]/30,
			  State.save_data["focus"]/30,
			  State.save_data["coordination"]/30,
			  State.save_data["reasoning"]/30]
var radius = 100.0
var attributes = [
	{"name": "Memória", "value": int(State.save_data["memory"])},
	{"name": "Agilidade", "value": int(State.save_data["agility"])},
	{"name": "Foco", "value": int(State.save_data["focus"])},
	{"name": "Coordenação", "value": int(State.save_data["coordination"])},
	{"name": "Raciocínio", "value": int(State.save_data["reasoning"])}
]

func _ready():
	var points = get_radar_points()
	$Polygon2D.polygon = points
	$Polygon2D.color = Color(0.213, 0.749, 0.749, 0.5)

func get_radar_points() -> Array:
	var result = []
	var total = values.size()
	for i in range(total):
		var angle = deg_to_rad(360.0 / total * i - 90.0)
		var r = radius * clamp(values[i], 0, 1)
		result.append(Vector2(cos(angle) * r, sin(angle) * r))
	return result
