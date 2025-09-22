extends Control

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

	$Label.text = nome_aleatorio
	$Label.add_theme_color_override("font_color", cor_aleatoria)

	cor_correta = cor_aleatoria

func conectar_botoes():
	for botao in $ColorButtons.get_children():
		botao.pressed.connect(func():
			_on_botao_pressionado(botao.text)
		)

func _on_botao_pressionado(nome_cor: String):
	var cor_escolhida = color_map.get(nome_cor, Color.WHITE)
	if cor_escolhida == cor_correta:
		print("✅ Correto!")
	else:
		print("❌ Errado!")
	gerar_desafio()
