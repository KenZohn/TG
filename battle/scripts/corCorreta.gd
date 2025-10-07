extends Control

signal game_finished(result)

var color_map = {
	"Vermelho": Color.RED,
	"Azul": Color.BLUE,
	"Verde": Color.GREEN,
	"Amarelo": Color.YELLOW
}

var cor_correta = Color.WHITE

func _ready():
	gerar_desafio()
	conectar_botoes()

func gerar_desafio():
	var nomes = color_map.keys()
	var nome_aleatorio = nomes[randi() % nomes.size()]
	var cor_aleatoria = color_map[nomes[randi() % nomes.size()]]

	$Panel/Label.text = nome_aleatorio
	$Panel/Label.add_theme_color_override("font_color", cor_aleatoria)

	cor_correta = cor_aleatoria

func conectar_botoes():
	for botao in $Panel/ColorButtons.get_children():
		botao.pressed.connect(func():
			_on_botao_pressionado(botao.text)
		)

func _on_botao_pressionado(nome_cor: String):
	$Panel/ColorButtons/ButtonEsquerda.disabled = true
	$Panel/ColorButtons/ButtonDireita.disabled = true
	$Panel/ColorButtons/ButtonCima.disabled = true
	$Panel/ColorButtons/ButtonBaixo.disabled = true
	var cor_escolhida = color_map.get(nome_cor, Color.WHITE)
	if cor_escolhida == cor_correta:
		print("✅ Correto!")
		emit_signal("game_finished", true) # Resultado retornado
	else:
		print("❌ Errado!")
		emit_signal("game_finished", false) # Resultado retornado
	#gerar_desafio()
