extends Control

signal textbox_closed

@export var enemy: Resource = null

var current_player_health = 0
var current_enemy_health = 0
var is_defending = false
var sudoku_instance: Node = null

func _ready():
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	$EnemyContainer/Enemy.texture = enemy.texture
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$TextBox.hide()
	$ActionsPanel.hide()
	$PlayerPanel.hide()
	$BattleBGM.play()
	
	display_text("Um %s selvagem apareceu!" % enemy.name.to_upper())
	await self.textbox_closed
	$ActionsPanel.show()
	$PlayerPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP %d/%d" % [health, max_health]

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$ActionsPanel.hide()
	$TextBox.show()
	$TextBox/Label.text = text

func enemy_turn():
	display_text("O %s te devolveu o tapão!" % enemy.name)
	await self.textbox_closed
	
	if is_defending:
		is_defending = false
		
		$AnimationPlayer.play("mini_shake")
		await $AnimationPlayer.animation_finished
		
		display_text("Você defendeu! Você defendeu!")
		await self.textbox_closed
	else:
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
		
		$AnimationPlayer.play("shake")
		$GetHitSE.play()
		await $AnimationPlayer.animation_finished
		
		display_text("O %s causou %d de danoninho em você!" % [enemy.name, enemy.damage])
		await self.textbox_closed
		
	if current_player_health == 0:
		display_text("Você perdeu!")
		await self.textbox_closed
		
		await get_tree().create_timer(0.25).timeout
		get_tree().quit()
	
	$ActionsPanel.show()

func _on_run_pressed() -> void:
	display_text("Corra quem puder!")
	await self.textbox_closed
	await get_tree().create_timer(0.25).timeout
	get_tree().quit()

func _on_sudoku_finished(resultado: bool):
	if resultado:
		await continue_attack()
	else:
		await get_tree().create_timer(0.5).timeout
		sudoku_instance.queue_free() # Finalizar instância do Sudoku
		display_text("Você errou o Sudoku... nada de daninho dessa vez.")
		await self.textbox_closed
		enemy_turn()

func _on_attack_pressed():
	$ActionsPanel.hide()
	
	var sudoku_scene = preload("res://src/sudoku3x3.tscn")
	sudoku_instance = sudoku_scene.instantiate()
	add_child(sudoku_instance)
	sudoku_instance.connect("sudoku_finished", Callable(self, "_on_sudoku_finished"))
	
func continue_attack():
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemy_damaged")
	$AttackSE.play()
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(0.25).timeout
	sudoku_instance.queue_free() # Finalizar instância do Sudoku
	
	display_text("Você causou %d de daninho!" % State.damage)
	await self.textbox_closed
	
	if current_enemy_health == 0:
		display_text("O %s foi derrotado!" % enemy.name)
		await self.textbox_closed
		
		$AnimationPlayer.play("enemy_died")
		$DefeatSE.play()
		await $AnimationPlayer.animation_finished
		
		await get_tree().create_timer(0.25).timeout
		get_tree().quit()
	
	enemy_turn()


func _on_defend_pressed() -> void:
	is_defending = true
	
	display_text("Você entrou na defensiva!")
	await self.textbox_closed
	
	await get_tree().create_timer(0.25).timeout
	
	enemy_turn()
