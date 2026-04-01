class_name SkillNode
extends TextureButton

var save_manager = preload("res://scripts/managers/save_manager.gd").new()

@export var skill_name : String
@export var unlocked : bool = false
@export var cost : int = 0

@export var health : int = 0
@export var time : int = 0
@export var damage : int = 0
@export var crit_chance : int = 0
@export var defense : int = 0

func _ready():
	if not unlocked:
		modulate = Color(0.4,0.4,0.4)
		
	pressed.connect(_on_pressed)

func _on_pressed():
	unlock_skill()

func unlock_skill():
	if unlocked:
		print("Já está desbloqueada")
		return
	
	if State.current_skill_point >= cost:
		print("Desbloqueou!")
		State.spend_skill_point()
		unlocked = true
		State.skills[name] = true
		modulate = Color(1,1,1)
		
		State.save_skills(health, crit_chance)
		save_manager.save_game(State.save_path)
