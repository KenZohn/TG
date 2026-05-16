extends Control

@onready var skills = $"MarginContainer/Panel/Skills"
@onready var ui_skill_title = $MarginContainer/Panel/UI/VBoxContainer/PanelDescription/MarginContainer/VBoxContainer/Title
@onready var ui_skill_description = $MarginContainer/Panel/UI/VBoxContainer/PanelDescription/MarginContainer/VBoxContainer/Description
@onready var ui_skill_confirm = $MarginContainer/Panel/UI/VBoxContainer/PanelDescription/MarginContainer/VBoxContainer/ConfirmButton
@onready var ui_skill_points = $MarginContainer/Panel/UI/VBoxContainer/PanelPoints/MarginContainer/VBoxContainer/SkillPoints

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

var description = {
	"health": {
		"title": "Vida é Bela",
		"text": "Aumenta a vida máxima."
	},
	"time":  {
		"title": "Tempo Precioso",
		"text": "Aumenta o tempo para solucionar os desafios."
	},
	"damage":  {
		"title": "Dano é Poder",
		"text": "Aumenta o dano máximo."
	},
	"critical":  {
		"title": "Crítico Certeiro",
		"text": "Aumenta a chance de dano crítico."
	},
	"defense": {
		"title": "Defesa Dura",
		"text": "Reduz o dano recebido."
	},
	"all": {
		"title": "Equilíbrio Mental",
		"text": "Melhora todos os cinco atributos."
	},
	"s_health": {
		"title": "Regeneração",
		"text": "Cura 5% da vida máxima por turno."
	},
	"s_time": {
		"title": "Volta no Tempo",
		"text": "Ao ser derrotado, volte com 25% de vida um vez por batalha."
	},
	"s_damage": {
		"title": "Evolução Constante",
		"text": "Aumenta 5% do dano a cada turno."
	},
	"s_critical": {
		"title": "Sorte em Dia",
		"text": "Causa 2x de dano crítico."
	},
	"s_defense": {
		"title": "Esquiva Perfeita",
		"text": "15% de chance de bloquear 100% do dano."
	},
	"start": {
		"title": "",
		"text": ""
	}
}

var skill_description = {
	"Start": description.start,
	"Skill_1": description.health,
	"Skill_2": description.time,
	"Skill_3": description.damage,
	"Skill_4": description.critical,
	"Skill_5": description.defense,
	"Skill_6": description.health,
	"Skill_7": description.critical,
	"Skill_8": description.time,
	"Skill_9": description.defense,
	"Skill_10": description.damage,
	"Skill_11": description.health,
	"Skill_12": description.critical,
	"Skill_13": description.time,
	"Skill_14": description.defense,
	"Skill_15": description.damage,
	"Skill_16": description.health,
	"Skill_17": description.health,
	"Skill_18": description.all,
	"Skill_19": description.critical,
	"Skill_20": description.damage,
	"Skill_21": description.time,
	"Skill_22": description.time,
	"Skill_23": description.all,
	"Skill_24": description.defense,
	"Skill_25": description.critical,
	"Skill_26": description.damage,
	"Skill_27": description.damage,
	"Skill_28": description.all,
	"Skill_29": description.health,
	"Skill_30": description.defense,
	"Skill_31": description.critical,
	"Skill_32": description.critical,
	"Skill_33": description.all,
	"Skill_34": description.time,
	"Skill_35": description.health,
	"Skill_36": description.defense,
	"Skill_37": description.defense,
	"Skill_38": description.all,
	"Skill_39": description.damage,
	"Skill_40": description.time,
	"Skill_41": description.defense,
	"Skill_42": description.health,
	"Skill_43": description.all,
	"Skill_44": description.s_health,
	"Skill_45": description.health,
	"Skill_46": description.time,
	"Skill_47": description.all,
	"Skill_48": description.s_time,
	"Skill_49": description.time,
	"Skill_50": description.damage,
	"Skill_51": description.all,
	"Skill_52": description.s_damage,
	"Skill_53": description.damage,
	"Skill_54": description.critical,
	"Skill_55": description.all,
	"Skill_56": description.s_critical,
	"Skill_57": description.critical,
	"Skill_58": description.defense,
	"Skill_59": description.all,
	"Skill_60": description.s_defense,
}

var highlighted_path = []
var selected_skill = null

func _ready() -> void:
	add_to_group("skill_tree")
	
	State.skill_points_changed.connect(update_label)
	
	initial_settings()
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
	ui_skill_points.text = str(int(State.current_skill_point))

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
		
		if skill == selected_skill:
			skill.modulate = Color(0.341, 0.825, 1.0, 1.0)
		elif skill.is_acquired:
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

func show_description(skill):
	selected_skill = skill
	ui_skill_title.text = skill_description[selected_skill.skill_name].title
	ui_skill_description.text = skill_description[selected_skill.skill_name].text
	update_all_visuals()
	
	if selected_skill.is_acquired:
		ui_skill_confirm.text = "ADQUIRIDA"
		ui_skill_confirm.disabled = true
	elif not has_unlocked_neighbor(selected_skill.skill_name):
		ui_skill_confirm.text = "BLOQUEADA"
		ui_skill_confirm.disabled = true
	elif State.current_skill_point < selected_skill.cost:
		ui_skill_confirm.text = "PONTOS INSUFICIENTE"
		ui_skill_confirm.disabled = true
	else:
		ui_skill_confirm.text = "ADQUIRIR"
		ui_skill_confirm.disabled = false

func _on_confirm_button_pressed() -> void:
	unlock_skill()

func unlock_skill():
	if selected_skill.is_acquired:
		print("Já adquirida")
		return
	
	if selected_skill.skill_tree == null:
		push_error("Skill tree não encontrada!")
		return
	
	if not has_unlocked_neighbor(selected_skill.skill_name):
		print("Skill bloqueada")
		return
	
	if State.current_skill_point < selected_skill.cost:
		print("Sem pontos")
		return
	
	State.spend_skill_point()
	selected_skill.is_acquired = true
	State.skills[selected_skill.skill_name] = true
	
	modulate = Color(1,1,1)
	
	State.save_skills(selected_skill.health, selected_skill.time, selected_skill.damage, selected_skill.crit_chance, selected_skill.defense, selected_skill.skill_name)
	
	update_all_visuals()
	print("Adquirida")


# Teste
func _on_debug_button_pressed() -> void:
	for skill in skills.get_children():
		if not skill.is_acquired:
			skill.is_acquired = true
			State.skills[skill.skill_name] = true
			State.save_skills(skill.health, skill.time, skill.damage, skill.crit_chance, skill.defense, skill.skill_name)
	update_all_visuals()

func initial_settings():
	ui_skill_title.text = ""
	ui_skill_description.text = ""
