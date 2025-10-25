extends Button

signal target_pressed(reaction_time)
var start_time = 0.0

func _ready():
	start_time = Time.get_ticks_msec()
	connect("pressed", _on_pressed)
	$Timer.start(2.0)

func _on_pressed():
	var reaction_time = (Time.get_ticks_msec() - start_time) / 1000.0
	emit_signal("target_pressed", reaction_time)
	queue_free()

func _on_Timer_timeout():
	queue_free()
