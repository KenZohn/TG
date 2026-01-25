@tool
extends Node2D

@onready var stage_panel = $Stages
@onready var hp_bar_label = $CanvasLayer/CharacterStats/LifeBar/Label
@onready var timer_bar_label = $CanvasLayer/CharacterStats/TimeBar/Label
@onready var exp_value_label = $CanvasLayer/CharacterStats/PanelExp/LabelExpValue

func _ready():
	BGMManager.play_bgm(BGMManager.bgm_stage_select)
	State.reset_state()
	update_stages()
	set_state()
	
	hp_bar_label.text = "%d/%d" % [State.max_hp, State.max_hp]
	timer_bar_label.text = "%.1f" % State.time
	exp_value_label.text = "%d" % State.save_data["experience"]

func update_stages():
	for child in stage_panel.get_children():
		if child.name.to_lower() in State.save_data and State.save_data[child.name.to_lower()]:
			var color_rect = child.get_node("ColorRect")
			color_rect.color = Color(0.596, 0.927, 0.521, 1.0)

func set_state():
	State.max_hp = 50 + 100 * State.save_data["memory"] * 0.01
	State.time = 15 + 5 * State.save_data["agility"] * 0.01
	State.damage_multiplier = 1 + 2 * State.save_data["focus"] * 0.01
	State.critical = 10 * State.save_data["coordination"] * 0.01
	State.defense = 10 * State.save_data["reasoning"] * 0.01

func _on_tittle_screen_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/title_screen.tscn")
