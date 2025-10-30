extends Button

const SCALE_NORMAL = Vector2(1.0, 1.0)
const SCALE_HOVER = Vector2(1.1, 1.1)
const SCALE_CLICK = Vector2(0.95, 0.95)
const OPACITY_NORMAL = 0.8
const OPACITY_HOVER = 1.0
const ANIMATION_DURATION = 0.3 

var tween: Tween = null

func _ready() -> void:
	connect("resized", _on_resized)
	_on_resized() 
	scale = SCALE_NORMAL
	modulate = Color(1, 1, 1, OPACITY_NORMAL)
	
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	connect("button_down", _on_button_down)
	connect("button_up", _on_button_up)

func _on_resized() -> void:
	if size.x > 0:
		pivot_offset = size / 2.0

func _on_mouse_entered() -> void:
	if tween != null and tween.is_running():
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(self, "scale", SCALE_HOVER, ANIMATION_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", OPACITY_HOVER, ANIMATION_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_mouse_exited() -> void:
	if tween != null and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", SCALE_NORMAL, ANIMATION_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", OPACITY_NORMAL, ANIMATION_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_button_down() -> void:
	if tween != null and tween.is_running():
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(self, "scale", SCALE_CLICK, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_button_up() -> void:
	if get_global_rect().has_point(get_global_mouse_position()):
		if tween != null and tween.is_running():
			tween.kill()
			
		tween = create_tween()
		tween.tween_property(self, "scale", SCALE_HOVER, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	else:
		_on_mouse_exited() 
