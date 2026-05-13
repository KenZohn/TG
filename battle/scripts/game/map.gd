@tool
extends Node2D

var is_moving = false
var current_stage = null

func _ready():
	BGMManager.play_bgm(BGMManager.bgm_stage_select)
	State.inventory.apply_bonus()
	connect_stages()
	update_stages()
	State.apply_player_state()
	draw_connections()

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
	$UI/InfoPanel.visible = true
	$UI/InfoPanel/Name.text = str(id)

func _on_enter_button_pressed():
	if current_stage != null:
		State.current_stage = current_stage
		FadeLayer.fade_to_scene("res://scenes/game/battle.tscn")

func connect_stages():
	for stage in $Stages.get_children():
		if stage.has_signal("stage_selected"):
			stage.stage_selected.connect(_on_stage_selected)

func update_stages():
	for stage in $Stages.get_children():
		var id = stage.stage_id
		
		var unlocked = StageData.is_stage_unlocked(id)
		var completed = StageData.is_stage_completed(id)
		
		stage.unlocked = unlocked
		
		var normal = StyleBoxFlat.new()
		var hover = StyleBoxFlat.new()
		var pressed = StyleBoxFlat.new()
		
		# Borda
		for s in [normal, hover, pressed]:
			s.corner_radius_top_left = 5
			s.corner_radius_top_right = 5
			s.corner_radius_bottom_left = 5
			s.corner_radius_bottom_right = 5
			
			s.border_width_left = 2
			s.border_width_right = 2
			s.border_width_top = 2
			s.border_width_bottom = 2
		
		if not unlocked:
			# Bloqueado
			normal.bg_color = Color(0.4, 0.4, 0.4)
			hover.bg_color = Color(0.5, 0.5, 0.5)
			pressed.bg_color = Color(0.3, 0.3, 0.3)
			
			for s in [normal, hover, pressed]:
				s.border_color = Color(0.3, 0.3, 0.3)
			
		elif completed:
			# Concluído
			normal.bg_color = Color(0.2, 0.8, 0.2)
			hover.bg_color = Color(0.3, 0.9, 0.3)
			pressed.bg_color = Color(0.15, 0.6, 0.15)
			
			for s in [normal, hover, pressed]:
				s.border_color = Color.WHITE
			
		else:
			# Desbloqueado
			normal.bg_color = Color(1, 1, 1)
			hover.bg_color = Color(0.85, 0.85, 0.85)
			pressed.bg_color = Color(0.7, 0.7, 0.7)
			
			for s in [normal, hover, pressed]:
				s.border_color = Color(0.2, 0.2, 0.2)
		
		# Texto
		if not unlocked:
			stage.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
			stage.add_theme_color_override("font_hover_color", Color(0.8, 0.8, 0.8))
			stage.add_theme_color_override("font_pressed_color", Color(0.8, 0.8, 0.8))
		elif completed:
			stage.add_theme_color_override("font_color", Color(0, 0, 0))
			stage.add_theme_color_override("font_hover_color", Color(0,0,0))
			stage.add_theme_color_override("font_pressed_color", Color(0,0,0))
		else:
			stage.add_theme_color_override("font_color", Color(0, 0, 0))
			stage.add_theme_color_override("font_hover_color", Color(0,0,0))
			stage.add_theme_color_override("font_pressed_color", Color(0,0,0))
		
		stage.add_theme_stylebox_override("normal", normal)
		stage.add_theme_stylebox_override("hover", hover)
		stage.add_theme_stylebox_override("pressed", pressed)

func _on_tittle_screen_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/ui/title_screen.tscn")

func _on_backpack_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/ui/backpack.tscn")

func _on_skill_tree_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/ui/skill_tree.tscn")

# Linhas das fases
func draw_connections():
	for child in $Lines.get_children():
		child.queue_free()
		
	for from_id in StageData.stage_graph:
		var from_node = get_stage_node(from_id)
		
		if from_node == null:
			continue
		
		for to_id in StageData.stage_graph[from_id]:
			var to_node = get_stage_node(to_id)
			
			if to_node == null:
				continue
			
			var line = Line2D.new()
			line.width = 8
			
			var from_pos = get_node_center(from_node)
			var to_pos = get_node_center(to_node)
			
			line.points = [
				from_pos,
				to_pos
			]
			
			if StageData.is_stage_completed(to_id):
				line.default_color = Color(0.2, 0.8, 0.2) # verde
			elif StageData.is_stage_unlocked(to_id):
				line.default_color = Color.WHITE
			else:
				line.default_color = Color(0.3, 0.3, 0.3)
			
			$Lines.add_child(line)

func get_node_center(node):
	if node is Control:
		var rect = node.get_global_rect()
		return rect.position + rect.size / 2
	else:
		return node.global_position

func get_stage_node(id):
	for stage in $Stages.get_children():
		if stage.stage_id == id:
			return stage
	return null

func _on_temp_loja_button_pressed() -> void:
	FadeLayer.fade_to_scene("res://scenes/ui/shop.tscn")


# Testes
func _on_debug_button_pressed():
	unlock_all_stages()
	update_stages()
	draw_connections()

func unlock_all_stages():
	for stage_id in StageData.stage_graph.keys():
		State.save_data[stage_id] = true
