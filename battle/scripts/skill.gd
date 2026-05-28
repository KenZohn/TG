class_name SkillNode
extends TextureButton

@export var skill_name : String
@export var is_acquired : bool = false
@export var cost : int = 0

@export var health : int = 0
@export var time : int = 0
@export var damage : int = 0
@export var crit_chance : int = 0
@export var defense : int = 0

var skill_tree : Node = null

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	var resultado = skill_tree.custo_uniforme_multiorigem(skill_name)
	
	if resultado != null:
		skill_tree.highlighted_path = resultado.path
		skill_tree.queue_redraw()
	
	skill_tree.show_cost(cost, resultado.cost)
	skill_tree.show_description(self, resultado.cost)
	print(resultado.path)
	
	
