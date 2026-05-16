extends Control

var values = [
	int(State.memory * 100 / 44),
	int(State.agility * 100 / 44),
	int(State.focus * 100 / 44),
	int(State.coordination * 100 / 44),
	int(State.reasoning * 100 / 44)
]

var radius = 100.0

func _ready():
	var points = get_radar_points()
	$RadarChart/Polygon2D.polygon = points
	$RadarChart/Polygon2D.color = Color(0.213, 0.749, 0.749, 0.5)
	
	show_stats()

func get_radar_points() -> Array:
	var result = []
	var total = values.size()
	for i in range(total):
		var angle = deg_to_rad(360.0 / total * i - 90.0)
		var r = radius * clamp(values[i], 0, 1)
		result.append(Vector2(cos(angle) * r, sin(angle) * r))
	return result

func show_stats():
	$LabelMemory.text = str(values[0])
	$LabelAgility.text = str(values[1])
	$LabelFocus.text = str(values[2])
	$LabelCoordination.text = str(values[3])
	$LabelReasoning.text = str(values[4])

func calc_stats():
	pass
