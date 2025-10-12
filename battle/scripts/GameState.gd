# GameState.gd
extends Node

# Estágio
var stage = "a2"
var game = "color" # react, color
var enemy = "slime"

# Recompensas
var memory = 0
var agility = 0
var focus = 0
var reasoning = 0
var coordination = 0

# Save
var save_data = {}
