extends Control

var values = []

var radius = 100.0

var memory = 0
var agility = 0
var focus = 0
var coordination = 0
var reasoning = 0

func _ready():
	calc_stats()
	
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
	$LabelMemory.text = str(int(values[0] * 100))
	$LabelAgility.text = str(int(values[1] * 100))
	$LabelFocus.text = str(int(values[2] * 100))
	$LabelCoordination.text = str(int(values[3] * 100))
	$LabelReasoning.text = str(int(values[4] * 100))

func calc_stats():
	memory = 0
	agility = 0
	focus = 0
	coordination = 0
	reasoning = 0
	
	for stage in State.save_data["stages"]:
		if stage == "Start":
			continue
		if StageData.stages[stage]["games"].any(func(g): return g.begins_with("m")):
			memory += 1
		if StageData.stages[stage]["games"].any(func(g): return g.begins_with("a")):
			agility += 1
		if StageData.stages[stage]["games"].any(func(g): return g.begins_with("f")):
			focus += 1
		if StageData.stages[stage]["games"].any(func(g): return g.begins_with("c")):
			coordination += 1
		if StageData.stages[stage]["games"].any(func(g): return g.begins_with("r")):
			reasoning += 1
	
	values = [
		memory / 44.0,
		agility / 44.0,
		focus / 44.0,
		coordination / 44.0,
		reasoning / 44.0
	]
