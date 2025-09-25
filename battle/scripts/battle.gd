extends Control

signal textbox_closed

@export var enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0
var game_scene: Node = null

# No emit_signal dos jogos, enviar: dano, se foi o finalizado e a animação desejada.s

var games = {
	"sudoku3x3": "res://scenes/sudoku3x3.tscn",
	"agility1": "res://scenes/GameFlashReact.tscn"
}

var titles = {
	"sudoku3x3": "Mini Sudoku",
	"agility1": "Reação"
}

var rules = {
	"sudoku3x3": "Complete a tabela com os números de 1 a 9 sem repetir.",
	"agility1": "Clique no botão o mais rápido possível quando o sinal aparecer."
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

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$RulesPanel.hide()
	$TextBox.show()
	$TextBox/Label.text = text

func enemy_turn():
	display_text("O %s te devolveu o tapão!" % enemy.name)
	await self.textbox_closed
	
	current_player_health = max(0, current_player_health - enemy.damage)
	set_health($PlayerPanel/ProgressBar, current_player_health, State.max_health)
	
	$AnimationPlayer.play("shake")
	$GetHitSE.play()
	await $AnimationPlayer.animation_finished
	
	display_text("O %s causou %d de danoninho em você!" % [enemy.name, enemy.damage])
	await self.textbox_closed
		
	if current_player_health == 0:
		display_text("Você perdeu!")
		await self.textbox_closed
		
		await get_tree().create_timer(0.25).timeout
		get_tree().change_scene_to_file("res://scenes/stage_select.tscn")
	
	$RulesPanel.show()

func _on_game_finished(resultado: bool):
	if resultado:
		await continue_attack()
	else:
		await get_tree().create_timer(0.5).timeout
		game_scene.queue_free() # Finalizar instância do jogo
		display_text("Você errou no jogo... nada de daninho dessa vez.")
		await self.textbox_closed
		enemy_turn()

func _on_start_button_pressed() -> void:
	$RulesPanel.hide()
	
	if games.has(GameState.game):
		var game_path = games[GameState.game]
		var game_resource = ResourceLoader.load(game_path)
		
		if game_resource:
			game_scene = game_resource.instantiate()
			add_child(game_scene)
			game_scene.connect("game_finished", Callable(self, "_on_game_finished"))
		else:
			print("Erro ao carregar cena:", game_path)
	else:
		print("Jogo não encontrado:", GameState.game)

func continue_attack():
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyPanel/ProgressBar, current_enemy_health, enemy.health)
	
	$EnemyPanel/DamageLabel.show()
	$AnimationPlayer.play("enemy_damaged")
	$AttackSE.play()
	await $AnimationPlayer.animation_finished
	$EnemyPanel/DamageLabel.hide()
	await get_tree().create_timer(0.25).timeout
	game_scene.queue_free() # Finalizar instância do jogo
	
	if current_enemy_health == 0:
		display_text("O %s foi derrotado!" % enemy.name)
		await self.textbox_closed
		
		$AnimationPlayer.play("enemy_died")
		$DefeatSE.play()
		await $AnimationPlayer.animation_finished
		
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/stage_select.tscn")
	
	enemy_turn()

func _on_run_pressed() -> void:
	display_text("Corra quem puder!")
	await self.textbox_closed
	await get_tree().create_timer(0.25).timeout
	get_tree().quit()
