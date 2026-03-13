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

		State.player_health += health
		State.player_time += time
		State.player_damage += damage
		State.player_crit_chance += crit_chance
		State.player_defense += defense
		
		State.save_data["player_health"] = State.player_health
		State.save_data["player_time"] = State.player_time
		State.save_data["player_damage"] = State.player_damage
		State.save_data["player_crit_chance"] = State.player_crit_chance
		State.save_data["player_defense"] = State.player_defense
		State.save_data["current_skill_point"] = State.current_skill_point
		State.save_data[name] = true
		
		save_manager.save_game(State.save_path)
