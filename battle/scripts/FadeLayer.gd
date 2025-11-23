extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var color_rect = $ColorRect

func fade_to_scene(scene_path: String):
	# Mostrar o ColorRect
	color_rect.visible = true
	
	# Fade out
	animation_player.play("fade_out")
	await animation_player.animation_finished
	
	# Trocar cena
	get_tree().change_scene_to_file(scene_path)
	
	# Fade in
	animation_player.play("fade_in")
	await animation_player.animation_finished
	
	# Esconder o ColorRect
	color_rect.visible = false
