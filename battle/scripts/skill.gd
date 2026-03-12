class_name SkillNode
extends TextureButton

@export var skill_name : String
@export var unlocked : bool = false

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
	
	print("Desbloqueou!")
	unlocked = true
	modulate = Color(1,1,1)

	State.player_health += health
	State.player_time += time
	State.player_damage += damage
	State.player_crit_chance += crit_chance
	State.player_defense += defense
	
