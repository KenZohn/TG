extends Control

var save_manager = preload("res://scripts/save_manager.gd").new()

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

@export var enemy: Resource = null

var current_player_hp = 0
var current_enemy_hp = 0
var game_scene: Node = null

var map = "res://scenes/map.tscn"
#var map = "res://scenes/stage_select.tscn"

var games = {
	"react": "res://scenes/game_react.tscn",
	"color": "res://scenes/game_color.tscn",
	"bomb": "res://scenes/game_bomb.tscn",
	"reflex": "res://scenes/game_reflex.tscn",
	"sort": "res://scenes/game_sort.tscn",
	"pop": "res://scenes/game_pop.tscn"
}

var titles = {
	"react": "Reação",
	"color": "Cor Correta",
	"bomb": "Caminho",
	"reflex": "Reflexo",
	"sort": "Classificação",
	"pop": "Menor ao Maior"
}

var rules = {
	"react": "Clique no botão o mais rápido possível quando o sinal aparecer.",
	"color": "Verifique se o SIGNIFICADO da palavra de CIMA coincide com a COR da palavra de BAIXO.",
	"bomb": "Una os dois pontos azuis sem encostar nas bombas.",
	"reflex": "Clique no botão o mais rápido possível.",
	"sort": "Clique no botão para o lado que a figura do meio se encontra.",
	"pop": "Clique nos botões na ordem do MENOR valor ao MAIOR."
}

var enemy_paths = {
	"slime": "res://resources/slime.tres",
	"zombie": "res://resources/zombie.tres",
	"goblin": "res://resources/goblin.tres"
}

func _ready():
	enemy = load(enemy_paths.get(State.enemy))
	set_hp(enemy_hp_bar, enemy.health, enemy.health)
	set_hp(player_hp_bar, State.max_hp, State.max_hp)
	enemy_texture.texture = enemy.texture
	
	rules_label.text = rules.get(State.game, "Descrição não disponível.")
	game_title.text = titles.get(State.game, "Título não disponível.")
	
	current_player_hp = State.max_hp
	current_enemy_hp = enemy.health
	
	BGMManager.play_bgm(load(enemy.bgm))
	
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
	
	if games.has(State.game):
		var game_path = games[State.game]
		var game_resource = ResourceLoader.load(game_path)
		
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
		
		State.save_data["experience"] += enemy.xp
		save_manager.save_game(State.save_path)
		
		display_text("O inimigo foi derrotado! \nVocê sente-se mais sábio... %d XP" % enemy.xp)
		await self.textbox_closed
		
		animation.play("enemy_died")
		defeat_se.play()
		await animation.animation_finished
		
		await get_tree().create_timer(0.5).timeout
		if is_inside_tree():
			FadeLayer.fade_to_scene(map)
	else:
		enemy_turn()
		timer_bar_label.text = "%.1f" % State.time
		timer_bar.value = State.time

func enemy_turn():
	var enemy_damage = enemy.damage - State.defense
	
	current_player_hp = max(0, current_player_hp - enemy_damage)
	set_hp(player_hp_bar, current_player_hp, State.max_hp)
	
	animation.play("shake")
	if get_hit_se.is_inside_tree():
		get_hit_se.play()
	await animation.animation_finished
	
	display_text("O %s causou %d de dano!" % [enemy.name, enemy_damage])
	await self.textbox_closed
		
	if current_player_hp == 0:
		display_text("Você perdeu!")
		await self.textbox_closed
		
		await get_tree().create_timer(0.25).timeout
		FadeLayer.fade_to_scene(map)
	
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
