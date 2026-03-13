extends Control

var save_manager = preload("res://scripts/managers/save_manager.gd").new()
var battle_summary_scene = preload("res://scenes/ui/battle_summary.tscn")

var stats = Stats.new()
var battle_start_time: float = 0.0

signal textbox_closed

@onready var player_panel = $PlayerPanel
@onready var player_hp_bar = $PlayerPanel/ProgressBar
@onready var timer_bar = $PlayerPanel/ProgressBarTimer
@onready var timer_bar_label = $PlayerPanel/ProgressBarTimer/Label
@onready var enemy_texture = $EnemyPanel/Enemy
@onready var enemy_hp_bar = $EnemyPanel/HPBar
@onready var enemy_damage_label = $EnemyPanel/DamageLabel
@onready var pause_screen = $PauseLayer/PauseScreen
@onready var rules_panel = $RulesPanel
@onready var game_title = $RulesPanel/TitleLabel
@onready var rules_label = $RulesPanel/RulesLabel
@onready var dialog_box = $DialogBox
@onready var dialog_box_text = $DialogBox/Text
@onready var count_label = $Count
@onready var animation = $AnimationPlayer
@onready var attack_se = $AttackSE
@onready var miss_se = $MissSE
@onready var defeat_se = $DefeatSE
@onready var get_hit_se = $GetHitSE
@onready var player_damage_label = $PlayerPanel/PlayerDamageLabel
@onready var background = $Background

@export var enemy: Resource = null

var current_player_hp = 0
var current_enemy_hp = 0
var game_scene: Node = null
var game_cycle: Array = []
var game_index: int = 0
var current_game: String

var map = "res://scenes/game/map.tscn"
#var map = "res://scenes/stage_select.tscn"

var games = {
	"m1": {
		"scene": "res://scenes/challenges/game_bomb.tscn",
		"title": "Caminho",
		"rule": "Una os dois pontos azuis sem encostar nas bombas."
	},
	"a1": {
		"scene": "res://scenes/challenges/game_color.tscn",
		"title": "Cor Correta",
		"rule": "Verifique se o SIGNIFICADO da palavra de CIMA coincide com a COR da palavra de BAIXO."
	},
	"f1": {
		"scene": "res://scenes/challenges/game_react.tscn",
		"title": "Reação",
		"rule": "Clique no botão o mais rápido possível quando o sinal aparecer."
	},
	"c1": {
		"scene": "res://scenes/challenges/game_reflex.tscn",
		"title": "Reflexo",
		"rule": "Clique no botão o mais rápido possível."
	},
	"r1": {
		"scene": "res://scenes/challenges/game_pop.tscn",
		"title": "Menor ao Maior",
		"rule": "Clique nos botões na ordem do MENOR valor ao MAIOR."
	},
	"m2": {
		"scene": "",
		"title": "",
		"rule": ""
	},
	"a2": {
		"scene": "",
		"title": "",
		"rule": ""
	},
	"f2": {
		"scene": "res://scenes/challenges/game_sort.tscn",
		"title": "Classificação",
		"rule": "Clique no botão para o lado que a figura do meio se encontra."
	},
	"c2": {
		"scene": "res://scenes/challenges/game_collect.tscn",
		"title": "Colete e Desvie",
		"rule": "Controle o personagem com o mouse e colete os itens enquanto evita os obstáculos."
	},
	"r2": {
		"scene": "res://scenes/challenges/game_unique.tscn",
		"title": "Único",
		"rule": "Clique na caixa que se difere das outras na cor, número ou forma."
	}
}

var enemy_paths = {
	"slime": "res://resources/slime.tres",
	"zombie": "res://resources/zombie.tres",
	"goblin": "res://resources/goblin.tres"
}

var background_paths = {
	"green_field": "res://assets/sprites/battleback10.png",
	"autumn_forest": "res://assets/sprites/battleback7.png",
	"desert": "res://assets/sprites/battleback3.png",
	"winter": "res://assets/sprites/battleback2.png",
	"forest": "res://assets/sprites/battleback1.png"
}

func _ready():
	enemy = load(enemy_paths.get(State.enemy))
	set_hp(enemy_hp_bar, enemy.health, enemy.health)
	set_hp(player_hp_bar, State.max_hp, State.max_hp)
	enemy_texture.texture = enemy.texture
	
	background.texture = load(background_paths.get(State.background))
	
	current_game = setup_game_cycle()
	var game_data = games[current_game]
	
	rules_label.text = game_data.rule
	game_title.text = game_data.title
	
	current_player_hp = State.max_hp
	current_enemy_hp = enemy.health
	
	BGMManager.play_bgm(load(enemy.bgm))
	
	stats.reset()
	battle_start_time = Time.get_ticks_msec() / 1000.0
	
	dialog_box.hide()
	rules_panel.hide()
	player_panel.hide()
	
	display_text("Um %s selvagem apareceu!" % enemy.name.to_upper())
	await self.textbox_closed
	player_panel.show()
	rules_panel.show()
	
	timer_bar_label.text = "%.1f" % State.time
	timer_bar.max_value = State.time
	timer_bar.value = State.time
	
	if enemy_damage_label.label_settings == null:
		enemy_damage_label.label_settings = LabelSettings.new()
		enemy_damage_label.label_settings.font_size = 25
		enemy_damage_label.label_settings.outline_size = 15
		enemy_damage_label.label_settings.outline_color = Color.html("#303030")
	
	if player_damage_label.label_settings == null:
		player_damage_label.label_settings = LabelSettings.new()
		player_damage_label.label_settings.font_size = 25
		player_damage_label.label_settings.outline_size = 15
		player_damage_label.label_settings.outline_color = Color.html("#303030")
		player_damage_label.label_settings.font_color = Color.ORANGE_RED
	
	for b in get_tree().get_nodes_in_group("se_buttons"):
		b.connect("pressed", Callable(self, "_on_any_button_pressed"))
		b.connect("mouse_entered", Callable(self, "_on_any_button_entered"))

func set_hp(progress_bar, hp, max_hp):
	progress_bar.value = hp
	progress_bar.max_value = max_hp
	progress_bar.get_node("HPLabel").text = "%d/%d" % [hp, max_hp]

func _input(_event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and dialog_box.visible:
		dialog_box.hide()
		emit_signal("textbox_closed")

func display_text(text):
	rules_panel.hide()
	dialog_box.show()
	dialog_box_text.text = text

func _on_start_button_pressed() -> void:
	rules_panel.hide()
	
	count_label.show()
	animation.play("count")
	await animation.animation_finished
	count_label.hide()
	
	if games.has(current_game):
		var game_data = games[current_game]
		var game_path = game_data.scene
		var game_resource = load(game_path)
		
		if game_resource:
			game_scene = game_resource.instantiate()
			add_child(game_scene)
			game_scene.connect("correct_answer_hit", Callable(self, "_on_correct_answer_hit"))
			game_scene.connect("wrong_answer", Callable(self, "_on_wrong_answer"))
			game_scene.connect("game_finished", Callable(self, "_on_game_finished"))
			game_scene.connect("timer_update", Callable(self, "_on_timer_update"))
		else:
			print("Erro ao carregar cena:", game_path)
	else:
		print("Jogo não encontrado:", State.game)

func _on_game_finished():
	await get_tree().create_timer(0.5).timeout
	if animation.is_playing():
		enemy_damage_label.hide()
		animation.stop()
		attack_se.stop()
	
	if game_scene:
		game_scene.queue_free()
		game_scene = null
		
	if current_enemy_hp == 0:
		var battle_end_time = Time.get_ticks_msec() / 1000.0
		var total_battle_time = battle_end_time - battle_start_time
		stats.time_taken = total_battle_time
		
		# Primeira vez completando o estágio
		if State.save_data[State.stage] == false:
			# Atribuir atributos
			State.save_data["memory"] += State.memory
			State.save_data["agility"] += State.agility
			State.save_data["focus"] += State.focus
			State.save_data["reasoning"] += State.reasoning
			State.save_data["coordination"] += State.coordination
			
			# Salvar jogo
			State.save_data[State.stage] = true
			
			State.save_data["current_skill_point"] += State.stage_skill_point
			State.current_skill_point += 1
		
		State.save_data["experience"] += enemy.xp
		State.save_data["player_position"] = [State.player_position.x, State.player_position.y]
		save_manager.save_game(State.save_path)
		
		display_text("O inimigo foi derrotado! \nVocê sente-se mais sábio... %d XP" % enemy.xp)
		await self.textbox_closed
		
		animation.play("enemy_died")
		defeat_se.play()
		await animation.animation_finished
		
		await get_tree().create_timer(0.5).timeout
		#if is_inside_tree():
			#FadeLayer.fade_to_scene(map)

		show_battle_summary(true, enemy.xp)
	else:
		current_game = get_next_game()
		var game_data = games[current_game]
	
		rules_label.text = game_data.rule
		game_title.text = game_data.title
		
		enemy_turn()
		timer_bar_label.text = "%.1f" % State.time
		timer_bar.value = State.time

func enemy_turn():
	var enemy_damage = enemy.damage - State.defense
	
	current_player_hp = max(0, current_player_hp - enemy_damage)
	set_hp(player_hp_bar, current_player_hp, State.max_hp)
	
	if animation.is_playing():
		player_damage_label.hide()
		animation.stop()
	
	player_damage_label.show()
	player_damage_label.text = "-%d" % enemy_damage
	animation.play("shake")
	if get_hit_se.is_inside_tree():
		get_hit_se.play()
	await animation.animation_finished
	player_damage_label.hide()
	
	display_text("O %s causou %d de dano!" % [enemy.name, enemy_damage])
	await self.textbox_closed
		
	if current_player_hp == 0:
		display_text("Você perdeu!")
		await self.textbox_closed
		await get_tree().create_timer(0.25).timeout
		
		State.save_data["player_position"] = [State.player_position.x, State.player_position.y]
		save_manager.save_game(State.save_path)
		
		# Transformar em função depois, trecho repetindo
		var battle_end_time = Time.get_ticks_msec() / 1000.0
		var total_battle_time = battle_end_time - battle_start_time
		stats.time_taken = total_battle_time
		show_battle_summary(false, 0)
	else:
		rules_panel.show()

func _on_correct_answer_hit(dano: int):
	State.damage = dano
	var damage = int(ceil(State.damage * State.damage_multiplier))

	# Crítico
	if randi() % 100 < State.critical:
		damage = int(floor(damage * 1.25))
		enemy_damage_label.label_settings.font_color = Color.RED
	else:
		enemy_damage_label.label_settings.font_color = Color.WHITE
		
	stats.register_hit(damage)
	
	current_enemy_hp = max(0, current_enemy_hp - damage)
	set_hp(enemy_hp_bar, current_enemy_hp, enemy.health)
	
	if animation.is_playing():
		enemy_damage_label.hide()
		animation.stop()
		attack_se.stop()
	
	enemy_damage_label.show()
	enemy_damage_label.text = str(damage)
	animation.play("enemy_damaged")
	attack_se.play()
	await animation.animation_finished
	enemy_damage_label.hide()
	await get_tree().create_timer(0.25).timeout

func _on_wrong_answer():
	stats.register_miss()
	
	if animation.is_playing():
		enemy_damage_label.hide()
		animation.stop()
		attack_se.stop()
	
	enemy_damage_label.show()
	enemy_damage_label.text = "MISS"
	animation.play("miss")
	miss_se.play()
	await animation.animation_finished
	enemy_damage_label.hide()
	await get_tree().create_timer(0.25).timeout

func _on_pause_button_pressed() -> void:
	get_tree().paused = not get_tree().paused
	pause_screen.visible = not pause_screen.visible

func _on_timer_update(time):
	timer_bar_label.text = "%.1f" % time
	timer_bar.value = time

func show_battle_summary(victory, xp):
	var summary = battle_summary_scene.instantiate()
	add_child(summary)
	$PauseLayer/PauseButton.visible = false
	
	var battle_stats = stats.get_summary()
	summary.show_summary(battle_stats, victory, xp)
	
	await summary.tree_exited
	
	await get_tree().create_timer(0.25).timeout
	if is_inside_tree():
		FadeLayer.fade_to_scene(map)

func setup_game_cycle():
	game_cycle = State.game.split(",")
	
	for i in range(game_cycle.size()):
		game_cycle[i] = game_cycle[i].strip_edges()
	
	game_cycle.shuffle()
	game_index = 0
	
	return game_cycle[0]

func get_next_game():
	game_index += 1
	
	if game_index >= game_cycle.size():
		#game_cycle.shuffle()
		game_index = 0
	
	var game_key = game_cycle[game_index]
	
	return game_key
