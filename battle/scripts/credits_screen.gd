extends Control

func _ready():
	var cards = [
		$OptionsContainer/PanelContainer/MarginContainer/VBoxContainer/JoaoContainer,
		$OptionsContainer/PanelContainer/MarginContainer/VBoxContainer/JohnnyContainer,
		$OptionsContainer/PanelContainer/MarginContainer/VBoxContainer/ThaisContainer,
		$OptionsContainer/PanelContainer/MarginContainer/VBoxContainer/MaouContainer
	]
	
	var delays = [0.1, 0.2, 0.3, 0.4] 
	
	for i in cards.size():
		var card = cards[i]
		card.modulate.a = 0
		card.position.x -= 20
		
		var tween = create_tween()
		
		tween.tween_property(card, "position:x", card.position.x + 20, 0.5).set_delay(delays[i])\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(card, "modulate:a", 1.0, 0.5).set_delay(delays[i])\
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_return_pressed():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
