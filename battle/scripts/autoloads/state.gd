# State.gd
extends Node

# Controle de Jogo
var is_new_game = false
var save_path = "";

# Personagem
var max_hp = 50
var time = 15
var damage_multiplier = 0
var critical = 0
var defense = 0
var damage = 10

# Estágio
var stage = "stage_1"
var game = "m1"
var background = "res://assets/sprites/battleback1.png"
var bgm = ""

# Inimigo
var enemy = "slime"
var enemy_hp = 45
var enemy_damage = 15

# Habilidades cognitivas
var memory = 0
var agility = 0
var focus = 0
var coordination = 0
var reasoning = 0

# Atributos
var player_health = 0
var player_time = 0
var player_damage = 0
var player_crit_chance = 0
var player_defense = 0

# Árvore de talentos
signal skill_points_changed

var stage_skill_point = 0
var total_skill_point = 0
var current_skill_point = 0

var skills = {
	"Start": true
}

func spend_skill_point():
	current_skill_point -= 1
	skill_points_changed.emit()

# Mapa
var player_position : Vector2 = Vector2.ZERO

# Save
var save_data = {}

func reset_state():
	State.memory = 0
	State.agility = 0
	State.focus = 0
	State.coordination = 0
	State.reasoning = 0

func reset_position():
	State.player_position = Vector2.ZERO
	
func save_skills(health = 0, crit_chance = 0):
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

# Mochila
var inventory = Inventory.new()

func _ready():
	add_child(inventory)
