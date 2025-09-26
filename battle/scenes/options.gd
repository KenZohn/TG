extends Control

@onready var master_slider = $MarginContainer/OptionsContainer/VolumeVContainer/SoundControl

var master_bus = AudioServer.get_bus_index("Master")

func _ready() -> void:
	var current_volume = AudioServer.get_bus_volume_db(master_bus)
	master_slider.value = current_volume

func _on_sound_control_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
