extends Node2D

var jogador_na_area = false

func _ready():
	State.reset_state()

func _process(_delta):
	if jogador_na_area and Input.is_action_just_pressed("ui_accept"):
		print("Entrou!")
		State.stage = "m1"
		State.game = "bomb"
		State.enemy = "slime"
		State.memory = 3
		FadeLayer.fade_to_scene("res://scenes/Battle.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		jogador_na_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		jogador_na_area = false
