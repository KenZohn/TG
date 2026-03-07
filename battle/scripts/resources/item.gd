extends Resource
class_name Item

@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D = null

@export var memory_bonus: int = 0
@export var agility_bonus: int = 0
@export var focus_bonus: int = 0
@export var reasoning_bonus: int = 0
@export var coordination_bonus: int = 0

func get_stats_bonus():
	return {
		"memory": memory_bonus,
		"agility": agility_bonus,
		"focus": focus_bonus,
		"reasoning": reasoning_bonus,
		"coordination": coordination_bonus
	}
