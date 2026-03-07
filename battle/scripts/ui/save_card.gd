extends "res://scripts/animated_button.gd"

@onready var margin_container = $MarginContainer

@onready var save_number_label = $MarginContainer/HBoxContainer/VBoxContainerLeft/SaveNumberLabel
@onready var hero_name_label = $MarginContainer/HBoxContainer/VBoxContainerLeft/HeroNameLabel
@onready var experience_label = $MarginContainer/HBoxContainer/VBoxContainerLeft/ExperienceLabel
@onready var last_save_label = $MarginContainer/HBoxContainer/LastSaveLabel

@onready var empty_save_container = $CenterContainer
@onready var empty_save_number_label = $CenterContainer/VBoxContainer/EmptySaveNumberLabel

func _ready():
	super._ready()

func set_save_data(data, slot_index):
	
	if data.get("empty", true):
		empty_save_number_label.text = "Save %d" % slot_index
		margin_container.hide()
		empty_save_container.show()
		
	else:
		save_number_label.text = "Save %d" % slot_index
		hero_name_label.text = "Herói: %s " % [data.get("character", "N/A")]
		experience_label.text = "Experiência: %s" % int(data.get("experience", "???"))
		last_save_label.text = data.get("last_played", "--:--")
