# State.gd
extends Node

var save_manager = preload("res://scripts/managers/save_manager.gd").new()

# Controle de Jogo
var is_new_game = false
var save_path = "";

# Personagem
var max_hp = 50
var time = 15
var damage_multiplier = 0
var critical = 0
var defense = 0

# Estágio
var current_stage = "W01-1"

# Atributos
var player_health = 0
var player_time = 0
var player_damage = 0
var player_crit_chance = 0
var player_defense = 0

# Árvore de talentos
signal skill_points_changed
var current_skill_point = 0
var skills = {
	"Start": true
}

# Habilidades Especiais
var s_health = false
var s_time = false
var s_damage = false
var s_critical = false
var s_defense = false

func spend_skill_point(skill_cost):
	current_skill_point -= skill_cost
	skill_points_changed.emit()

# Save
var save_data = {}

func save_skills(skill_health = 0, skill_time = 0, skill_damage = 0, skill_crit_chance = 0, skill_defense = 0, skill_name = ""):
	State.player_health += skill_health
	State.player_time += skill_time
	State.player_damage += skill_damage
	State.player_crit_chance += skill_crit_chance
	State.player_defense += skill_defense
	
	State.save_data["player_health"] = State.player_health
	State.save_data["player_time"] = State.player_time
	State.save_data["player_damage"] = State.player_damage
	State.save_data["player_crit_chance"] = State.player_crit_chance
	State.save_data["player_defense"] = State.player_defense
	State.save_data["current_skill_point"] = State.current_skill_point
	State.save_data[skill_name] = true
	save_manager.save_game(State.save_path)

func apply_player_state():
	State.max_hp = 50 + State.player_health * 5
	State.time = 15 + State.player_time * 0.25
	State.damage_multiplier = 1 + State.player_damage * 0.1
	State.critical = State.player_crit_chance * 0.5
	State.defense = State.player_defense * 0.5
	load_s_skills()

func load_s_skills():
	for skill_name in State.skills:
		if skill_name == "Skill_44":
			s_health = true
		if skill_name == "Skill_48":
			s_time = true
		if skill_name == "Skill_52":
			s_damage = true
		if skill_name == "Skill_56":
			s_critical = true
		if skill_name == "Skill_60":
			s_defense = true

# Mochila
var inventory = Inventory.new()

func _ready():
	add_child(inventory)
