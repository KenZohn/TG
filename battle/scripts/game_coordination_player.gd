extends CharacterBody2D

func _ready():
	add_to_group("player")

func _process(_delta):
	var mouse_pos = global_position.lerp(get_viewport().get_camera_2d().get_global_mouse_position(), 0.1)
	var area = get_parent().game_area
	mouse_pos.x = clamp(mouse_pos.x, 0, area.x)
	mouse_pos.y = clamp(mouse_pos.y, 0, area.y)
	global_position = mouse_pos
