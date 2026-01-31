extends Node2D

@export var speed: float = 150
@export var screen_bounds: Rect2 = Rect2(Vector2.ZERO, Vector2(800, 600))

var direction: Vector2

func _ready():
	# Gera direção aleatória normalizada
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _process(delta):
	var area = get_parent().game_area
	position += direction * speed * delta
	
	if position.x <= 0 or position.x >= area.x:
		direction.x *= -1
		position.x = clamp(position.x, 0, area.x)
	if position.y <= 0 or position.y >= area.y:
		direction.y *= -1
		position.y = clamp(position.y, 0, area.y)
