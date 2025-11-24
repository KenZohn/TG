extends Area2D

var jogador_na_area = false

func _ready():
	State.reset_state()

func _process(_delta):
	if jogador_na_area and Input.is_action_just_pressed("ui_accept"):
		SESelect.play()
		State.stage = "c3"
		State.game = "reflex"
		State.enemy = "goblin"
		State.coordination = 5
		FadeLayer.fade_to_scene("res://scenes/Battle.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		jogador_na_area = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		jogador_na_area = false
