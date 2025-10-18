extends Control

var save_manager = preload("res://scripts/SaveManager.gd").new()

func _on_slot_1_pressed():
	handle_slot("res://saves/save1.save")
	
func _on_slot_2_pressed():
	handle_slot("res://saves/save2.save")
	
func _on_slot_3_pressed():
	handle_slot("res://saves/save3.save")
	
func handle_slot(path):
	if State.is_new_game:
		save_manager.new_game(path)
	else:
		if not save_manager.load_game(path):
			$ErrorLabel.visible = true
			$ErrorLabel.text = "Nenhum save encontrado."
			await get_tree().create_timer(1.0).timeout
			$ErrorLabel.visible = false
			return
	
	State.save_path = path  
	#print("Dados carregados:", State.save_data)
	get_tree().change_scene_to_file("res://scenes/StageSelect.tscn")
