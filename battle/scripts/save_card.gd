extends Control

func set_save_data(data):
	$Button/MarginContainer/HBoxContainer/Left/Save.text = data.get("slot_name", "SAVE")
	$Button/MarginContainer/HBoxContainer/Left/Name.text = data.get("character", "???")
	$Button/MarginContainer/HBoxContainer/Right/LastSaveDate.text = data.get("last_played", "--/--/----")
	$Button/MarginContainer/HBoxContainer/Right/XP.text = "Lv " + str(data.get("level", 0))
