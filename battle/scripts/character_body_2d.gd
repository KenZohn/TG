extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 150.0
const JUMP_VELOCITY = -150.0

func _ready():
	add_to_group("jogador")

func _physics_process(_delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# Horizontal movement (left/right)
	var direction_x := Input.get_axis("left", "right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("left"):
		$AnimatedSprite2D.play("andando_tras")
		
	if Input.is_action_just_pressed("right"):
		$AnimatedSprite2D.play("andando_frente")
	
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
			anim.play("walk")
		else:
			anim.play('idle')
	else:
		anim.play('jump')
	
	move_and_slide()
	
	 # colocar o codigo para pular (jump) botao espaço fisico
	
