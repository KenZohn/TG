extends Area2D

signal zoom_in_transition

@export var phase_name: String
@export var stage: String
@export var game: String
@export var enemy: String
@export var agility: int
@export var memory: int
@export var focus: int
@export var coordination: int
@export var reasoning: int

var jogador_na_area = false

func _ready():
	State.reset_state()
	connect("input_event", Callable(self, "_on_input_event"))

func _process(_delta):
	if jogador_na_area and Input.is_action_just_pressed("ui_accept"):
		enter_stage()

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		enter_stage()

func enter_stage():
	SESelect.play()
	State.stage = stage
	State.game = game
	State.enemy = enemy
	State.agility = agility
	State.memory = memory
	State.focus = focus
	State.coordination = coordination
	State.reasoning = reasoning
	emit_signal("zoom_in_transition")
	FadeLayer.fade_to_scene("res://scenes/battle.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		jogador_na_area = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		jogador_na_area = false
