extends Camera2D

var game_area = Vector2(1280, 720)

func _ready():
	zoom = Vector2(1, 1)
	limit_left = 0
	limit_top = 0
	limit_right = game_area.x
	limit_bottom = game_area.y
	
	# Centralizar a câmera
	global_position = game_area / 2
