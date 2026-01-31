extends Node2D

@export var item_scene: PackedScene
@export var spawn_area: Rect2 = Rect2(Vector2(0,0), Vector2(800,600))

@export var obstacle_scene: PackedScene
@export var obstacle_count: int = 5

@export var game_area: Vector2 = Vector2(500, 500)

var items_left = 0

func _ready():
	spawn_items(5)
	spawn_obstacles(obstacle_count)

func spawn_items(count: int):
	items_left = count
	var area = game_area
	for i in range(count):
		var item = item_scene.instantiate()
		var random_x = randf_range(0, area.x)
		var random_y = randf_range(0, area.y)
		item.global_position = Vector2(random_x, random_y)
		add_child(item)
		
		item.connect("item_collected", Callable(self, "_on_item_collected"))

func spawn_obstacles(count: int):
	for i in range(count):
		var obstacle = obstacle_scene.instantiate()
		var random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
		var random_y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		obstacle.position = Vector2(random_x, random_y)
		add_child(obstacle)

func _on_item_collected():
	items_left -= 1
	if items_left <= 0:
		call_deferred("spawn_items", 5)
