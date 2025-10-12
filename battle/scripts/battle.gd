extends Control

signal textbox_closed

@export var enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0
var game_scene: Node = null

# No emit_signal dos jogos, enviar: dano, se foi o finalizado e a animação desejada.s

var games = {
	"react": "res://scenes/GameReact.tscn",
	"color": "res://scenes/GameColor.tscn",
	"bomb": "res://scenes/GameBomb.tscn"
}

var titles = {
	"react": "Reação",
	"color": "Cor Correta",
	"bomb": "Caminho"
}

var rules = {
	"react": "Clique no botão o mais rápido possível quando o sinal aparecer.",
	"color": "Verifique se o SIGNIFICADO da palavra de CIMA coincide com a COR da palavra de BAIXO.",
	"bomb": "Una os dois pontos azuis sem encostar nas bombas."
}

func _ready():
	set_health($EnemyPanel/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/ProgressBar, State.current_health, State.max_health)
	$EnemyPanel/Enemy.texture = enemy.texture
	
	$RulesPanel/RulesLabel.text = rules.get(GameState.game, "Descrição não disponível.")
	$RulesPanel/TitleLabel.text = titles.get(GameState.game, "Título não disponível.")
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$TextBox.hide()
	$RulesPanel.hide()
	$PlayerPanel.hide()
	$BattleBGM.play()
	
	display_text("Um %s selvagem apareceu!" % enemy.name.to_upper())
	await self.textbox_closed
	$PlayerPanel.show()
	$RulesPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "%d/%d" % [health, max_health]

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
	
	if games.has(GameState.game):
		var game_path = games[GameState.game]
		var game_resource = ResourceLoader.load(game_path)
		
		if game_resource:
			game_scene = game_resource.instantiate()
			add_child(game_scene)
			game_scene.connect("correct_answer_hit", Callable(self, "_on_correct_answer_hit"))
			game_scene.connect("game_finished", Callable(self, "_on_game_finished"))
		else:
			print("Erro ao carregar cena:", game_path)
	else:
		print("Jogo não encontrado:", GameState.game)

func _on_game_finished(_resultado: bool):
	await get_tree().create_timer(0.5).timeout
	if $AnimationPlayer.is_playing():
		$EnemyPanel/DamageLabel.hide()
		$AnimationPlayer.stop()
		$AttackSE.stop()
	
	if game_scene:
		game_scene.queue_free()
		game_scene = null
		
	if current_enemy_health == 0:
		# Primeira vez completando o estágio
		if GameState.save_data[GameState.stage] == false:
			# Atribuir atributos
			GameState.save_data["memory"] += GameState.memory
			GameState.save_data["agility"] += GameState.agility
			GameState.save_data["focus"] += GameState.focus
			GameState.save_data["reasoning"] += GameState.reasoning
			GameState.save_data["coordination"] += GameState.coordination
			
			# Salvar jogo
			GameState.save_data[GameState.stage] = true
			var file = FileAccess.open("res://saves/save1.save", FileAccess.WRITE)
			var json_string = JSON.stringify(GameState.save_data)
			file.store_string(json_string)
			file.close()
		
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
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyPanel/ProgressBar, current_enemy_health, enemy.health)
	
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
	current_player_health = max(0, current_player_health - enemy.damage)
	set_health($PlayerPanel/ProgressBar, current_player_health, State.max_health)
	
	$AnimationPlayer.play("shake")
	$GetHitSE.play()
	await $AnimationPlayer.animation_finished
	
	display_text("O %s causou %d de dano!" % [enemy.name, enemy.damage])
	await self.textbox_closed
		
	if current_player_health == 0:
		display_text("Você perdeu!")
		await self.textbox_closed
		
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("res://scenes/StageSelect.tscn")
	
	$RulesPanel.show()

func _on_correct_answer_hit(dano: int):
	State.damage = dano
	await continue_attack()
