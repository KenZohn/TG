extends Area2D

signal obstacle_hit

@export var speed: float = 150
@export var screen_bounds: Rect2 = Rect2(Vector2.ZERO, Vector2(800, 600))

var direction: Vector2

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	# Gera direção aleatória normalizada
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _process(delta):
	var game_rect = get_parent().game_rect  # pega o retângulo completo do Node2D pai
	position += direction * speed * delta
	
	# Limite horizontal
	if position.x <= game_rect.position.x or position.x >= game_rect.position.x + game_rect.size.x:
		direction.x *= -1
		position.x = clamp(position.x, game_rect.position.x, game_rect.position.x + game_rect.size.x)
	
	# Limite vertical
	if position.y <= game_rect.position.y or position.y >= game_rect.position.y + game_rect.size.y:
		direction.y *= -1
		position.y = clamp(position.y, game_rect.position.y, game_rect.position.y + game_rect.size.y)

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("obstacle_hit")
