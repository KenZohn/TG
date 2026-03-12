extends Control

@onready var skills = $"Skills"

var connections = [
	["Start", "Skill_1"],
	["Start", "Skill_2"],
	["Start", "Skill_3"],
	["Start", "Skill_4"],
	["Start", "Skill_5"],
	["Skill_1", "Skill_6"],
	["Skill_1", "Skill_8"],
	["Skill_2", "Skill_8"],
	["Skill_2", "Skill_10"],
	["Skill_3", "Skill_10"],
	["Skill_3", "Skill_12"],
	["Skill_4", "Skill_12"],
	["Skill_4", "Skill_14"],
	["Skill_5", "Skill_14"],
	["Skill_5", "Skill_6"],
	["Skill_6", "Skill_7"],
	["Skill_7", "Skill_8"],
	["Skill_8", "Skill_9"],
	["Skill_9", "Skill_10"],
	["Skill_10", "Skill_11"],
	["Skill_11", "Skill_12"],
	["Skill_12", "Skill_13"],
	["Skill_13", "Skill_14"],
	["Skill_14", "Skill_15"],
	["Skill_15", "Skill_6"],
]

var highlighted_path = []

func _ready() -> void:
	pass

func _process(_delta):
	queue_redraw()

func _draw():
	for c in connections:
		var a = skills.get_node_or_null(c[0])
		var b = skills.get_node_or_null(c[1])

		if a == null or b == null:
			continue

		var pos_a = (a.global_position + a.size / 2) - global_position
		var pos_b = (b.global_position + b.size / 2) - global_position

		var color = Color.GRAY
		var width = 2

		if c in highlighted_path:
			color = Color.GOLD
			width = 5

		draw_line(pos_a, pos_b, color, width)
