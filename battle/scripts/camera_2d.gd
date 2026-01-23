extends Camera2D

var min_zoom: float = 0.5
var max_zoom: float = 3.0
var zoom_step: float = 0.2

func _ready():
	make_current()  # FORÇA esta câmera ser a atual

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				var new_zoom = zoom - Vector2(zoom_step, zoom_step)
				if new_zoom.x > min_zoom:
					zoom = new_zoom
			
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				var new_zoom = zoom + Vector2(zoom_step, zoom_step)
				if new_zoom.x < max_zoom:
					zoom = new_zoom
