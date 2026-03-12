@tool
extends Node2D

@onready var stage_panel = $Stages
@onready var hp_bar_label = $CanvasLayer/CharacterStats/LifeBar/Label
@onready var timer_bar_label = $CanvasLayer/CharacterStats/TimeBar/Label
@onready var exp_value_label = $CanvasLayer/CharacterStats/PanelExp/LabelExpValue

func _ready():
	BGMManager.play_bgm(BGMManager.bgm_stage_select)
	State.reset_state()
	State.inventory.apply_bonus()
	update_stages()
	set_state()
	
	hp_bar_label.text = "%d/%d" % [State.max_hp, State.max_hp]
	timer_bar_label.text = "%.1f" % State.time
	exp_value_label.text = "%d" % State.save_data["experience"]

func update_stages():
	# Apagar depois que alterar para fases mescladas
	for child in stage_panel.get_children():
		if child.name.to_lower() in State.save_data and State.save_data[child.name.to_lower()]:
			var color_rect = child.get_node("ColorRect")
			color_rect.color = Color(0.596, 0.927, 0.521, 1.0)
	
	for child in stage_panel.get_children():
		var stage_key = "stage_" + child.name
		
		if State.save_data.get(stage_key, false):
			var color_rect = child.get_node("ColorRect")
			color_rect.color = Color(0.596, 0.927, 0.521, 1.0)

func set_state():
	# Testando pegar os dados diretamente, ao invés de pegar do save data
	#State.max_hp = 50 + 100 * State.memory * 0.01
	#State.time = 15 + 5 * State.agility * 0.01
	#State.damage_multiplier = 1 + 2 * State.focus * 0.01
	#State.critical = 10 * State.coordination * 0.01
	#State.defense = 10 * State.reasoning * 0.01
	
	State.max_hp = 50 + State.player_health * 5
	State.time = 15 + State.player_time * 0.25
	State.damage_multiplier = 1 + State.player_damage * 0.1
	State.critical = State.player_crit_chance * 0.5
	State.defense = State.player_defense * 0.5
	
	print("Vida: ", State.player_health)
	print("Tempo: ", State.player_time)
	print("Dano: ", State.player_damage)
	print("Crit: ", State.player_crit_chance)
	print("Defesa: ", State.player_defense)

func _on_tittle_screen_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/ui/title_screen.tscn")

func _on_backpack_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/ui/backpack.tscn")

func _on_skill_tree_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/ui/skill_tree.tscn")
