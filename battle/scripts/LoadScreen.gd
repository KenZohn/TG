extends Control


func _on_slot_1_pressed() -> void:
	if FileAccess.file_exists("res://saves/save1.save"):
		var file = FileAccess.open("res://saves/save1.save", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		  
		State.save_data = data
		get_tree().change_scene_to_file("res://scenes/StageSelect.tscn")
	else:
		$ErrorLabel.visible = true
		$ErrorLabel.text = "Nenhum save encontrado."
		await get_tree().create_timer(1.0).timeout
		$ErrorLabel.visible = false


func _on_slot_2_pressed() -> void:
	if FileAccess.file_exists("res://saves/save2.save"):
		var file = FileAccess.open("res://saves/save2.save", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		  
		State.save_data = data
		get_tree().change_scene_to_file("res://scenes/StageSelect.tscn")
	else:
		$ErrorLabel.visible = true
		$ErrorLabel.text = "Nenhum save encontrado."
		await get_tree().create_timer(1.0).timeout
		$ErrorLabel.visible = false


func _on_slot_3_pressed() -> void:
	if FileAccess.file_exists("res://saves/save3.save"):
		var file = FileAccess.open("res://saves/save3.save", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		  
		State.save_data = data
		get_tree().change_scene_to_file("res://scenes/StageSelect.tscn")
	else:
		$ErrorLabel.visible = true
		$ErrorLabel.text = "Nenhum save encontrado."
		await get_tree().create_timer(1.0).timeout
		$ErrorLabel.visible = false
