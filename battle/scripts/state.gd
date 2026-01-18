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
var stage = "a2"
var game = "color"

# Inimigo
var enemy = "slime"
var enemy_hp = 45
var enemy_damage = 15

# Recompensas
var memory = 0
var agility = 0
var focus = 0
var coordination = 0
var reasoning = 0

# Save
var save_data = {}

func reset_state():
	State.memory = 0
	State.agility = 0
	State.focus = 0
	State.coordination = 0
	State.reasoning = 0
