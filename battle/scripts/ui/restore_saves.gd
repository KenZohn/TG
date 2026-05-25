extends Control

@onready var my_id_label = $CenterContainer/VBoxContainer/Panel/MarginContainer/VBox/MyIdSection/MyIdLabel
@onready var input_field = $CenterContainer/VBoxContainer/Panel/MarginContainer/VBox/InputRow/IdInput
@onready var restore_button = $CenterContainer/VBoxContainer/Panel/MarginContainer/VBox/InputRow/RestoreButton
@onready var status_label = $CenterContainer/VBoxContainer/Panel/MarginContainer/VBox/StatusLabel

func _ready():
	my_id_label.text = "Seu ID: %s" % PlayerIdManager.player_id
	status_label.text = ""

func _on_copy_id_pressed():
	DisplayServer.clipboard_set(PlayerIdManager.player_id)
	status_label.text = "ID copiado!"
	status_label.add_theme_color_override("font_color", Color(0.5, 1, 0.5, 1))

func _on_restore_pressed():
	var target_id = input_field.text.strip_edges()
	
	if target_id.is_empty():
		status_label.text = "Digite um ID válido!"
		status_label.add_theme_color_override("font_color", Color(1, 0.4, 0.4, 1))
		return
	
	if target_id == PlayerIdManager.player_id:
		status_label.text = "Esse já é o seu ID!"
		status_label.add_theme_color_override("font_color", Color(1, 0.8, 0.2, 1))
		return
	
	restore_button.disabled = true
	status_label.text = "Buscando saves..."
	status_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.7))
	
	OnlineManager.restore_saves_from_id(target_id, _on_restore_done)

func _on_restore_done(success: bool, message: String):
	restore_button.disabled = false
	status_label.text = message
	
	if success:
		status_label.add_theme_color_override("font_color", Color(0.5, 1, 0.5, 1))
		my_id_label.text = "Seu ID: %s" % PlayerIdManager.player_id
	else:
		status_label.add_theme_color_override("font_color", Color(1, 0.4, 0.4, 1))

func _on_close_pressed():
	FadeLayer.fade_to_scene("res://scenes/ui/options.tscn")