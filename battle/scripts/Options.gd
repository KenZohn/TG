extends Control

@onready var music_slider = $CenterContainer/OptionsContainer/PanelContainer/MarginContainer/GridContainer/MusicControl
@onready var sfx_slider = $CenterContainer/OptionsContainer/PanelContainer/MarginContainer/GridContainer/SFXControl

var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	var current_music_volume = AudioServer.get_bus_volume_db(music_bus)
	music_slider.value = current_music_volume
	
	var current_sfx_volume = AudioServer.get_bus_volume_db(sfx_bus)
	sfx_slider.value = current_sfx_volume

func _on_sound_control_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(music_bus, true)
	else:
		AudioServer.set_bus_mute(music_bus, false)

func _on_sfx_control_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(sfx_bus, true)
	else:
		AudioServer.set_bus_mute(sfx_bus, false)

func _on_return_pressed() -> void:
	SESelect.play()
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")

func _on_return_mouse_entered() -> void:
	SEMouseEntered.play()
