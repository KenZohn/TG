extends Node2D

signal correct_answer_hit(damages)
signal wrong_answer()
signal game_finished()
signal timer_update(time)

@export var item_scene: PackedScene
@export var spawn_area: Rect2 = Rect2(Vector2(0,0), Vector2(380,320))
@export var obstacle_scene: PackedScene
@export var obstacle_count: int = 5
@export var game_area: Vector2 = Vector2(380, 320)
@export var game_origin: Vector2 = Vector2(0, 0)

@export var rect_size: Vector2 = Vector2(300, 200)
@export var rect_color: Color = Color(0.0, 0.0, 0.0, 0.706)
@export var corner_radius: float = 20.0
@export var border_margin: float = 10.0

@onready var game_timer = $TimerGame
@onready var interval_timer = $TimerInterval
@onready var display_timer = $TimerDisplay

var game_rect: Rect2
var items_left = 0
var damage = 3
var awaiting_response: bool = false

func _ready():
	var screen_size = get_viewport_rect().size
	var origin_x = (screen_size.x - game_area.x) / 2
	var origin_y = screen_size.y - game_area.y - 35
	
	game_origin = Vector2(origin_x, origin_y)
	
	# área interna com margem
	var inner_origin = game_origin + Vector2(border_margin, border_margin)
	var inner_size = game_area - Vector2(border_margin * 2, border_margin * 2)
	game_rect = Rect2(inner_origin, inner_size)
	
	setup_timers()
	start_timer()
	spawn_items(5)
	spawn_obstacles(obstacle_count)
	display_timer.timeout.connect(_update_timer_display)

func spawn_items(count: int):
	items_left = count
	for i in range(count):
		var item = item_scene.instantiate()
		var random_x = randf_range(game_rect.position.x, game_rect.position.x + game_rect.size.x)
		var random_y = randf_range(game_rect.position.y, game_rect.position.y + game_rect.size.y)
		item.global_position = Vector2(random_x, random_y)
		add_child(item)
		
		item.connect("item_collected", Callable(self, "_on_item_collected"))

func spawn_obstacles(count: int):
	for i in range(count):
		var obstacle = obstacle_scene.instantiate()
		var random_x = randf_range(game_rect.position.x, game_rect.position.x + game_rect.size.x)
		var random_y = randf_range(game_rect.position.y, game_rect.position.y + game_rect.size.y)
		obstacle.position = Vector2(random_x, random_y)
		add_child(obstacle)
		
		obstacle.connect("obstacle_hit", Callable(self, "_on_obstacle_hit"))

func _on_item_collected():
	emit_signal("correct_answer_hit", damage)
	items_left -= 1
	if items_left <= 0:
		call_deferred("spawn_items", 5)

func _on_obstacle_hit():
	emit_signal("wrong_answer")
	_apply_time_penalty()

func start_timer():
	game_timer.start()
	game_timer.timeout.connect(_on_game_timeout)

func _update_timer_display():
	var remaining = game_timer.time_left
	emit_signal("timer_update", remaining)

func setup_timers():
	game_timer.wait_time = State.time
	game_timer.one_shot = true
	game_timer.timeout.connect(_on_game_timeout)
	
	interval_timer.wait_time = 0.1
	interval_timer.one_shot = true
	interval_timer.timeout.connect(_on_interval_timeout)
	
	display_timer.wait_time = 0.1
	display_timer.one_shot = false
	display_timer.start()

func _on_interval_timeout():
	if game_timer.is_stopped():
		return

func _on_game_timeout():
	interval_timer.stop()
	awaiting_response = false
	
	emit_signal("game_finished")

func _apply_time_penalty():
	var remaining = game_timer.time_left
	var new_time = max(remaining - 2.0, 0.1)
	game_timer.stop()
	game_timer.wait_time = new_time
	game_timer.start()

func _draw():
	var style = StyleBoxFlat.new()
	style.bg_color = rect_color
	style.corner_radius_top_left = corner_radius
	style.corner_radius_top_right = corner_radius
	style.corner_radius_bottom_left = corner_radius
	style.corner_radius_bottom_right = corner_radius
	
	draw_style_box(style, Rect2(game_origin, game_area))
