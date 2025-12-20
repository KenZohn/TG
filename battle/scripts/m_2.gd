extends Area2D

var jogador_na_area = false

func _ready():
	State.reset_state()

func _process(_delta):
	if jogador_na_area and Input.is_action_just_pressed("ui_accept"):
		SESelect.play()
		State.stage = "m2"
		State.game = "bomb"
		State.enemy = "zombie"
		State.memory = 4
		FadeLayer.fade_to_scene("res://scenes/battle.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		jogador_na_area = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		jogador_na_area = false
