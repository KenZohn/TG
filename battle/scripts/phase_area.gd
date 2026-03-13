extends Area2D

signal zoom_in_transition

@export var stage: String
@export var game: String
@export var background: String
@export var bgm: String
@export var enemy: String
@export var enemy_hp: int
@export var enemy_damage: int

@export var memory: int
@export var agility: int
@export var focus: int
@export var coordination: int
@export var reasoning: int

@export var skill_point: int

var jogador_na_area = false

func _ready():
	State.reset_state()
	connect("input_event", Callable(self, "_on_input_event"))
	
	var mapa = get_parent().get_parent()
	var character = mapa.get_node("CharacterBody2D")
	character.connect("zoom_finished", Callable(self, "_on_zoom_finished"))

func _process(_delta):
	if jogador_na_area and Input.is_action_just_pressed("ui_accept"):
		enter_stage()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		enter_stage()

func enter_stage():
	State.stage = stage
	State.game = game
	State.background = background
	State.bgm = bgm
	State.enemy = enemy
	State.enemy_hp = enemy_hp
	State.enemy_damage = enemy_damage
	
	# Vai deixar de existir
	State.agility = agility
	State.memory = memory
	State.focus = focus
	State.coordination = coordination
	State.reasoning = reasoning
	
	# Será substituído por esse
	State.stage_skill_point = skill_point
	
	play_enter_stage_se()
	emit_signal("zoom_in_transition")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		jogador_na_area = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		jogador_na_area = false

func play_enter_stage_se():
	var enter_stage_se : AudioStream = preload("res://assets/audio/se/maou_se_battle02.ogg")
	var player = AudioStreamPlayer.new()
	player.stream = enter_stage_se
	player.bus= "SFX"
	player.volume_db = -10
	add_child(player)
	player.play()
	player.connect("finished", Callable(player, "queue_free"))

func _on_zoom_finished():
	var mapa = get_parent().get_parent()
	var character = mapa.get_node("CharacterBody2D")
	State.player_position = character.global_position
	
	FadeLayer.fade_to_scene("res://scenes/game/battle.tscn")
