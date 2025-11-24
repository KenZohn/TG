extends Control

var save_manager = preload("res://scripts/SaveManager.gd").new()

signal textbox_closed

@export var enemy: Resource = null

var current_player_hp = 0
var current_enemy_hp = 0
var game_scene: Node = null

var games = {
	"react": "res://scenes/GameReact.tscn",
	"color": "res://scenes/GameColor.tscn",
	"bomb": "res://scenes/GameBomb.tscn",
	"reflex": "res://scenes/GameReflex.tscn",
	"sort": "res://scenes/GameSort.tscn",
	"pop": "res://scenes/GamePop.tscn"
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
	set_hp($EnemyPanel/ProgressBar, enemy.health, enemy.health)
	set_hp($PlayerPanel/ProgressBar, State.max_hp, State.max_hp)
	$EnemyPanel/Enemy.texture = enemy.texture
	
	$RulesPanel/RulesLabel.text = rules.get(State.game, "Descrição não disponível.")
	$RulesPanel/TitleLabel.text = titles.get(State.game, "Título não disponível.")
	
	current_player_hp = State.max_hp
	current_enemy_hp = enemy.health
	
	$BattleBGM.stream = load(enemy.bgm)
	
	$TextBox.hide()
	$RulesPanel.hide()
	$PlayerPanel.hide()
	$BattleBGM.play()
	
	display_text("Um %s selvagem apareceu!" % enemy.name.to_upper())
	await self.textbox_closed
	$PlayerPanel.show()
	$RulesPanel.show()
	
	$PlayerPanel/ProgressBarTimer/Label.text = "%.1f" % State.time
	
	if $EnemyPanel/DamageLabel.label_settings == null:
		$EnemyPanel/DamageLabel.label_settings = LabelSettings.new()
		$EnemyPanel/DamageLabel.label_settings.font_size = 25
		$EnemyPanel/DamageLabel.label_settings.outline_size = 15
		$EnemyPanel/DamageLabel.label_settings.outline_color = Color.html("#303030")
	
	for b in get_tree().get_nodes_in_group("se_buttons"):
		b.connect("pressed", Callable(self, "_on_any_button_pressed"))
		b.connect("mouse_entered", Callable(self, "_on_any_button_entered"))

func set_hp(progress_bar, hp, max_hp):
	progress_bar.value = hp
	progress_bar.max_value = max_hp
	progress_bar.get_node("Label").text = "%d/%d" % [hp, max_hp]

func _input(_event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$RulesPanel.hide()
	$TextBox.show()
	$TextBox/Label.text = text

func _on_start_button_pressed() -> void:
	$RulesPanel.hide()
	$PlayerPanel/ProgressBarTimer.hide()
	
	if games.has(State.game):
		var game_path = games[State.game]
		var game_resource = ResourceLoader.load(game_path)
		
		if game_resource:
			game_scene = game_resource.instantiate()
			add_child(game_scene)
			game_scene.connect("correct_answer_hit", Callable(self, "_on_correct_answer_hit"))
			game_scene.connect("game_finished", Callable(self, "_on_game_finished"))
		else:
			print("Erro ao carregar cena:", game_path)
	else:
		print("Jogo não encontrado:", State.game)

func _on_game_finished(_resultado: bool):
	await get_tree().create_timer(0.5).timeout
	if $AnimationPlayer.is_playing():
		$EnemyPanel/DamageLabel.hide()
		$AnimationPlayer.stop()
		$AttackSE.stop()
	
	if game_scene:
		game_scene.queue_free()
		game_scene = null
		
	if current_enemy_hp == 0:
		$PlayerPanel/ProgressBarTimer.show()
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
			
			save_manager.save_game(State.save_path)
		
		State.save_data["experience"] += enemy.xp
		save_manager.save_game(State.save_path)
		display_text("O inimigo foi derrotado! \nVocê sente-se mais sábio... %d XP" % enemy.xp)
		await self.textbox_closed
		
		$AnimationPlayer.play("enemy_died")
		$DefeatSE.play()
		await $AnimationPlayer.animation_finished
		
		await get_tree().create_timer(0.5).timeout
		if is_inside_tree():
			#FadeLayer.fade_to_scene("res://scenes/StageSelect.tscn")
			FadeLayer.fade_to_scene("res://scenes/mapa.tscn")
	else:
		enemy_turn()

func continue_attack():
	var damage = int(ceil(State.damage * State.damage_multiplier))

	# Crítico
	if randi() % 100 < State.critical:
		damage = int(floor(damage * 1.25))
		$EnemyPanel/DamageLabel.label_settings.font_color = Color.RED
	else:
		$EnemyPanel/DamageLabel.label_settings.font_color = Color.WHITE
	
	current_enemy_hp = max(0, current_enemy_hp - damage)
	set_hp($EnemyPanel/ProgressBar, current_enemy_hp, enemy.health)
	
	if $AnimationPlayer.is_playing():
		$EnemyPanel/DamageLabel.hide()
		$AnimationPlayer.stop()
		$AttackSE.stop()
	
	$EnemyPanel/DamageLabel.show()
	$EnemyPanel/DamageLabel.text = str(damage)
	$AnimationPlayer.play("enemy_damaged")
	$AttackSE.play()
	await $AnimationPlayer.animation_finished
	$EnemyPanel/DamageLabel.hide()
	await get_tree().create_timer(0.25).timeout

func enemy_turn():
	var enemy_damage = enemy.damage - State.defense
	
	$PlayerPanel/ProgressBarTimer.show()
	
	current_player_hp = max(0, current_player_hp - enemy_damage)
	set_hp($PlayerPanel/ProgressBar, current_player_hp, State.max_hp)
	
	$AnimationPlayer.play("shake")
	if $GetHitSE.is_inside_tree():
		$GetHitSE.play()
	await $AnimationPlayer.animation_finished
	
	display_text("O %s causou %d de dano!" % [enemy.name, enemy_damage])
	await self.textbox_closed
		
	if current_player_hp == 0:
		display_text("Você perdeu!")
		await self.textbox_closed
		
		await get_tree().create_timer(0.25).timeout
		#FadeLayer.fade_to_scene("res://scenes/StageSelect.tscn")
		FadeLayer.fade_to_scene("res://scenes/mapa.tscn")
	
	$RulesPanel.show()

func _on_correct_answer_hit(dano: int):
	State.damage = dano
	await continue_attack()

func _on_pause_button_pressed() -> void:
	get_tree().paused = not get_tree().paused
	$PauseLayer/PauseScreen.visible = not $PauseLayer/PauseScreen.visible
