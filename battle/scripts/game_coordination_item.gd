extends Area2D
signal item_collected

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("item_collected")
		queue_free()
