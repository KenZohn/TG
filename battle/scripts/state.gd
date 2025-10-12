# State.gd
extends Node

# Personagem
var current_hp = 35
var max_hp = 35
var damage = 30

# Estágio
var stage = "a2"
var game = "color" # react, color

# Inimigo
var enemy = "slime"
var enemy_hp = 45
var enemy_damage = 15

# Recompensas
var memory = 0
var agility = 0
var focus = 0
var reasoning = 0
var coordination = 0

# Save
var save_data = {}
