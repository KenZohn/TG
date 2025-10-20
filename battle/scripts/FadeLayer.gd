extends CanvasLayer

@onready var anim := $AnimationPlayer
@onready var rect := $ColorRect

func fade_to_scene(scene_path: String):
	anim.play("fade_out")
	await anim.animation_finished
	get_tree().change_scene_to_file(scene_path)
	anim.play("fade_in")
