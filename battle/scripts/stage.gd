extends Button

signal stage_selected(stage_id, target_position)

@export var stage_id: String

var unlocked = false

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	if not unlocked:
		return
	
	var target_pos = get_global_rect().get_center()
	emit_signal("stage_selected", stage_id, target_pos)
