extends CharacterBody2D

func mover_personagem(destino):
	var tween = create_tween()
	tween.tween_property($PlayerIcon, "global_position", destino, 0.5)
