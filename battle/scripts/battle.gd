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
	"sort": "res://scenes/GameSort.tscn"
}

var titles = {
	"react": "Reação",
	"color": "Cor Correta",
	"bomb": "Caminho",
	"reflex": "Reflexo",
	"sort": "Classificação"
}

var rules = {
	"react": "Clique no botão o mais rápido possível quando o sinal aparecer.",
	"color": "Verifique se o SIGNIFICADO da palavra de CIMA coincide com a COR da palavra de BAIXO.",
	"bomb": "Una os dois pontos azuis sem encostar nas bombas.",
	"reflex": "Clique no botão o mais rápido possível.",
	"sort": "Clique no botão para o lado que a figura do meio se encontra."
}

var enemy_paths = {
	"slime": "res://resources/slime.tres",
	"zombie": "res://resources/zombie.tres",
	"goblin": "res://resources/goblin.tres"
}

func _ready():
	enemy = load(enemy_paths.get(State.enemy))
	set_hp($EnemyPanel/ProgressBar, enemy.health, enemy.health)
	set_hp($PlayerPanel/ProgressBar, State.current_hp, State.max_hp)
	$EnemyPanel/Enemy.texture = enemy.texture
	
	$RulesPanel/RulesLabel.text = rules.get(State.game, "Descrição não disponível.")
	$RulesPanel/TitleLabel.text = titles.get(State.game, "Título não disponível.")
	
	current_player_hp = State.current_hp
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
		
		display_text("O %s foi derrotado!" % enemy.name)
		await self.textbox_closed
		
		$AnimationPlayer.play("enemy_died")
		$DefeatSE.play()
		await $AnimationPlayer.animation_finished
		
		await get_tree().create_timer(0.5).timeout
		if is_inside_tree():
			get_tree().change_scene_to_file("res://scenes/StageSelect.tscn")
	
	enemy_turn()

func continue_attack():
	current_enemy_hp = max(0, current_enemy_hp - State.damage)
	set_hp($EnemyPanel/ProgressBar, current_enemy_hp, enemy.health)
	
	if $AnimationPlayer.is_playing():
		$EnemyPanel/DamageLabel.hide()
		$AnimationPlayer.stop()
		$AttackSE.stop()
	
	$EnemyPanel/DamageLabel.show()
	$EnemyPanel/DamageLabel.text = str(State.damage)
	$AnimationPlayer.play("enemy_damaged")
	$AttackSE.play()
	await $AnimationPlayer.animation_finished
	$EnemyPanel/DamageLabel.hide()
	await get_tree().create_timer(0.25).timeout

func enemy_turn():
	current_player_hp = max(0, current_player_hp - enemy.damage)
	set_hp($PlayerPanel/ProgressBar, current_player_hp, State.max_hp)
	
	$AnimationPlayer.play("shake")
	if $GetHitSE.is_inside_tree():
		$GetHitSE.play()
	await $AnimationPlayer.animation_finished
	
	display_text("O %s causou %d de dano!" % [enemy.name, enemy.damage])
	await self.textbox_closed
		
	if current_player_hp == 0:
		display_text("Você perdeu!")
		await self.textbox_closed
		
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("res://scenes/StageSelect.tscn")
	
	$RulesPanel.show()

func _on_correct_answer_hit(dano: int):
	State.damage = dano
	await continue_attack()
