extends "res://scripts/AnimatedButton.gd"

@onready var margin_container = $MarginContainer

@onready var save_number_label = $MarginContainer/HBoxContainer/VBoxContainerLeft/SaveNumberLabel
@onready var hero_name_label = $MarginContainer/HBoxContainer/VBoxContainerLeft/HeroNameLabel
@onready var experience_label = $MarginContainer/HBoxContainer/VBoxContainerLeft/ExperienceLabel
@onready var last_save_label = $MarginContainer/HBoxContainer/LastSaveLabel

@onready var empty_save_container = $CenterContainer

func _ready():
	super._ready()

func set_save_data(data):
	if data.get("empty", true):
		save_number_label.text = data.get("slot_name", "SLOT VAZIO")
		margin_container.hide()
		empty_save_container.show()
		
	else:
		save_number_label.text = data.get("slot_name", "SAVE ")
		hero_name_label.text = "Herói: %s " % [data.get("character", "N/A")]
		experience_label.text = "Experiência: %s" % int(data.get("experience", "???"))
		last_save_label.text = data.get("last_played", "--:--")
