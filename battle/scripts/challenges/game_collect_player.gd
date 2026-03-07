extends CharacterBody2D

func _ready():
	add_to_group("player")

func _process(_delta):
	var mouse_pos = global_position.lerp(get_viewport().get_camera_2d().get_global_mouse_position(), 0.1)
	var game_rect = get_parent().game_rect  # pega do Node2D pai
	
	mouse_pos.x = clamp(mouse_pos.x, game_rect.position.x, game_rect.position.x + game_rect.size.x)
	mouse_pos.y = clamp(mouse_pos.y, game_rect.position.y, game_rect.position.y + game_rect.size.y)
	global_position = mouse_pos
