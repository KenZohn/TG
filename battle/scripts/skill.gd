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
	if not is_acquired:
		modulate = Color(0.4,0.4,0.4)
		
	pressed.connect(_on_pressed)

func _on_pressed():
	unlock_skill()

func unlock_skill():
	if is_acquired:
		print("Já adquirida")
		return
	
	if skill_tree == null:
		push_error("Skill tree não encontrada!")
		return
	
	if not skill_tree.has_unlocked_neighbor(skill_name):
		print("Skill bloqueada")
		return
	
	if State.current_skill_point < cost:
		print("Sem pontos")
		return
	
	State.spend_skill_point()
	is_acquired = true
	State.skills[skill_name] = true
	
	modulate = Color(1,1,1)
	
	State.save_skills(health, time, damage, crit_chance, defense, skill_name)
	
	skill_tree.update_all_visuals()
	print("Adquirida")
