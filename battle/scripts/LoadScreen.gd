extends Control

var save_manager = preload("res://scripts/SaveManager.gd").new()
var pending_path

func _ready():
	var paths = [
		"res://saves/save1.save"
		,"res://saves/save2.save"
		,"res://saves/save3q.save"
	]
	
	var card_container = $CenterContainer/MarginContainer/VBoxContainerPrincipal/CardContainer
	
	for path in paths:
		var data = get_save_preview(path)
		var card = preload("res://scenes/SaveCard.tscn").instantiate()
		card_container.add_child(card)
		card.set_save_data(data)
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
	#FadeLayer.fade_to_scene("res://scenes/StageSelect.tscn")
	FadeLayer.fade_to_scene("res://scenes/mapa.tscn")

func get_save_preview(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"empty": true}
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"empty": true}
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var result = json.parse(json_string)
	if result != OK or typeof(json.data) != TYPE_DICTIONARY:
		return {"empty": true}
		
	var data = json.data
	
	return {
		"empty": false,
		"slot_name": path.get_file().get_basename().to_upper(),
		"character": "Herói",
		"level": 1,
		"location": "Local desconhecido",
		"playtime": "0h 00min",
		"last_played": "--/--/---- - --:--"
	}
