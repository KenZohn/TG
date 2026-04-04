@tool
extends Node2D

@onready var stage_panel = $Stages

var is_moving = false
var current_stage = null

func _ready():
	#BGMManager.play_bgm(BGMManager.bgm_stage_select)
	State.inventory.apply_bonus()
	connect_stages()
	update_stages()
	apply_player_state()

func _on_stage_selected(id, target_position):
	current_stage = id
	
	move_player(target_position)
	show_stage_info(id)

func move_player(target_position):
	if is_moving:
		return
		
	is_moving = true
	
	var tween = create_tween()
	tween.tween_property($PlayerIcon, "global_position", target_position, 0.5)
	
	tween.finished.connect(func():
		is_moving = false
	)

func show_stage_info(id):
	$CanvasLayer/InfoPanel.visible = true
	
	$CanvasLayer/InfoPanel/Name.text = "Stage " + str(id)
	$CanvasLayer/InfoPanel/Description.text = StageData.stages.get(id, {}).get("description", "")

func _on_enter_button_pressed():
	if current_stage != null:
		State.current_stage = current_stage
		FadeLayer.fade_to_scene("res://scenes/game/battle.tscn")

func connect_stages():
	for stage in stage_panel.get_children():
		if stage.has_signal("stage_selected"):
			stage.stage_selected.connect(_on_stage_selected)

func update_stages():
	for stage in stage_panel.get_children():
		var id = stage.stage_id
		
		stage.unlocked = StageData.is_stage_unlocked(id)

func apply_player_state():
	State.max_hp = 50 + State.player_health * 5
	State.time = 15 + State.player_time * 0.25
	State.damage_multiplier = 1 + State.player_damage * 0.1
	State.critical = State.player_crit_chance * 0.5
	State.defense = State.player_defense * 0.5

func _on_tittle_screen_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/ui/title_screen.tscn")

func _on_backpack_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/ui/backpack.tscn")

func _on_skill_tree_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/ui/skill_tree.tscn")
