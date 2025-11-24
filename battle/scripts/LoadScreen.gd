extends Control

var save_manager = preload("res://scripts/SaveManager.gd").new()
var pending_path

func _ready():
	var paths = [
		"res://saves/save1.save"
		,"res://saves/save2.save"
		,"res://saves/save3.save"
	]
	
	var card_container = $CenterContainer/MarginContainer/VBoxContainerPrincipal/CardContainer
	
	for i in range(paths.size()):
		var path = paths[i]
		var data = get_save_preview(path, i+1)
		var card = preload("res://scenes/SaveCard.tscn").instantiate()
		card_container.add_child(card)
		card.set_save_data(data, i+1)
		card.pressed.connect(handle_slot.bind(path))

func handle_slot(path):
	if State.is_new_game:
		if FileAccess.file_exists(path):
			pending_path = path
			$OverwriteDialog.popup_centered()
			return
		else:
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
	#FadeLayer.fade_to_scene("res://scenes/StageSelect.tscn")
	FadeLayer.fade_to_scene("res://scenes/mapa.tscn")

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")

func _on_overwrite_dialog_confirmed() -> void:
	save_manager.new_game(pending_path)
	State.save_path = pending_path
	SESelect.play()
	#FadeLayer.fade_to_scene("res://scenes/StageSelect.tscn")
	FadeLayer.fade_to_scene("res://scenes/mapa.tscn")

func get_save_preview(path: String, slot_index: int) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"empty": true, "slot_name": "Save %d" % slot_index}
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"empty": true, "slot_name": "Save %d" % slot_index}
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var result = json.parse(json_string)
	if result != OK or typeof(json.data) != TYPE_DICTIONARY:
		return {"empty": true, "slot_name": "Save %d" % slot_index}
		
	var data = json.data
	
	var timestamp = FileAccess.get_modified_time(path)
	var datetime = Time.get_datetime_dict_from_unix_time(timestamp)
	var formatted_date = "%02d/%02d/%04d - %02d:%02d" % [
		datetime.day, datetime.month, datetime.year, datetime.hour, datetime.minute
	]
	
	return {
		"empty": false,
		"slot_name": "Save %d" % slot_index,
		"character": "Herói",
		"experience": data.get("experience", 0),
		"location": "Local desconhecido",
		"playtime": "0h 00min",
		"last_played": formatted_date
	}
