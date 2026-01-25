extends CharacterBody2D

signal zoom_finished

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera = $Camera2D

const SPEED = 150.0
const JUMP_VELOCITY = -150.0

func _ready():
	add_to_group("jogador")
	set_player_position()

	var mapa = get_parent()
	var stages = mapa.get_node("Stages")

	for stage in stages.get_children():
		if stage.has_signal("zoom_in_transition"):
			stage.connect("zoom_in_transition", Callable(self, "_on_zoom_in_transition"))

func _physics_process(_delta: float) -> void:
	# Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# Horizontal movement (left/right)
	var direction_x := Input.get_axis("left", "right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("left"):
		anim.play("andando_tras")
		
	if Input.is_action_just_pressed("right"):
		anim.play("andando_frente")
	
	# Vertical movement (up/down) - CORRIGIDO
	var direction_y := Input.get_axis("up", "down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		# Aplica desaceleração vertical sempre (não só no chão/teto)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	# Animation handling
	if is_on_floor():
		if direction_x > 0:
			anim.flip_h = false
			anim.play("andando_tras")
		elif direction_x < 0:
			anim.flip_h = true
			anim.play("andando_frente")
		#else:
			#anim.play('idle')
	#else:
		#anim.play('jump')
	
	move_and_slide()
	
	 # colocar o codigo para pular (jump) botao espaço fisico

func _on_zoom_in_transition():
	var tween = create_tween()
	camera.zoom = Vector2(1.8,1.8)
	tween.tween_property(camera, "zoom", Vector2(5,5), 0.5)

	await tween.finished
	emit_signal("zoom_finished")

func set_player_position():
	if State.save_data.has("player_position"):
		var pos = State.save_data["player_position"]
		State.player_position = Vector2(pos[0], pos[1])
	
	if State.player_position != Vector2.ZERO:
		get_tree().current_scene.get_node("CharacterBody2D").global_position = State.player_position
