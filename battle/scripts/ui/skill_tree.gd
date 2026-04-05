extends Control

@onready var skills = $"Skills"
@onready var skill_points = $"LabelSkillPointValue"

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
	["Skill_16", "Skill_15"],
	["Skill_16", "Skill_40"],
	["Skill_16", "Skill_17"],
	["Skill_17", "Skill_18"],
	["Skill_18", "Skill_19"],
	["Skill_19", "Skill_20"],
	["Skill_20", "Skill_7"],
	["Skill_20", "Skill_21"],
	["Skill_21", "Skill_7"],
	["Skill_21", "Skill_22"],
	["Skill_22", "Skill_23"],
	["Skill_23", "Skill_24"],
	["Skill_24", "Skill_25"],
	["Skill_25", "Skill_9"],
	["Skill_25", "Skill_26"],
	["Skill_26", "Skill_9"],
	["Skill_26", "Skill_27"],
	["Skill_27", "Skill_28"],
	["Skill_28", "Skill_29"],
	["Skill_29", "Skill_30"],
	["Skill_30", "Skill_11"],
	["Skill_30", "Skill_31"],
	["Skill_31", "Skill_11"],
	["Skill_31", "Skill_32"],
	["Skill_32", "Skill_33"],
	["Skill_33", "Skill_34"],
	["Skill_34", "Skill_35"],
	["Skill_35", "Skill_13"],
	["Skill_35", "Skill_36"],
	["Skill_36", "Skill_13"],
	["Skill_36", "Skill_37"],
	["Skill_37", "Skill_38"],
	["Skill_38", "Skill_39"],
	["Skill_39", "Skill_40"],
	["Skill_40", "Skill_15"],
	["Skill_18", "Skill_41"],
	["Skill_41", "Skill_42"],
	["Skill_42", "Skill_43"],
	["Skill_43", "Skill_44"],
	["Skill_23", "Skill_45"],
	["Skill_45", "Skill_46"],
	["Skill_46", "Skill_47"],
	["Skill_47", "Skill_48"],
	["Skill_28", "Skill_49"],
	["Skill_49", "Skill_50"],
	["Skill_50", "Skill_51"],
	["Skill_51", "Skill_52"],
	["Skill_33", "Skill_53"],
	["Skill_53", "Skill_54"],
	["Skill_54", "Skill_55"],
	["Skill_55", "Skill_56"],
	["Skill_38", "Skill_57"],
	["Skill_57", "Skill_58"],
	["Skill_58", "Skill_59"],
	["Skill_59", "Skill_60"]
]

var highlighted_path = []

func _ready() -> void:
	add_to_group("skill_tree")
	
	State.skill_points_changed.connect(update_label)
	
	update_label()
	load_skills()
	
	assign_skill_tree_to_nodes()

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
		
		var state = get_connection_state(c[0], c[1])

		var color
		var width = 3

		match state:
			"active":
				color = Color(1.0, 1.0, 1.0, 1.0)
			
			"available":
				color = Color(0.3, 0.3, 0.3)
			
			"locked":
				color = Color(0.3, 0.3, 0.3)
		
		draw_line(pos_a, pos_b, color, width)

func load_skills():
	for skill_name in State.skills:
		if State.skills[skill_name]:
			var skill = skills.get_node_or_null(skill_name)
			
			if skill:
				skill.is_acquired = true
	
	update_all_visuals()

func update_label():
	skill_points.text = str(int(State.current_skill_point))

func has_unlocked_neighbor(skill_id):
	for c in connections:
		var a = c[0]
		var b = c[1]
		
		if skill_id == a and State.skills.get(b, false):
			return true
		
		if skill_id == b and State.skills.get(a, false):
			return true
	
	return false

func update_all_visuals():
	for skill in skills.get_children():
		var id = skill.skill_name
		
		if skill.is_acquired:
			skill.modulate = Color(1,1,1)
		elif has_unlocked_neighbor(id):
			skill.modulate = Color(0.7,0.7,0.2)
		else:
			skill.modulate = Color(0.3,0.3,0.3)

func assign_skill_tree_to_nodes():
	for skill in skills.get_children():
		skill.skill_tree = self

func _on_back_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/game/map.tscn")





func get_connection_state(a, b):
	var a_acquired = State.skills.get(a, false)
	var b_acquired = State.skills.get(b, false)
	
	if a_acquired and b_acquired:
		return "active"
	
	if a_acquired or b_acquired:
		return "available"
	
	return "locked"
