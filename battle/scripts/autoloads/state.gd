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

# Mochila
var inventory = Inventory.new()

func _ready():
	add_child(inventory)
