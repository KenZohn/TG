extends Control

@onready var items_grid = $MainContainer/ShopPanel/MarginContainer/VBoxContainer/ScrollContainer/ItemsGrid
@onready var xp_label = $MainContainer/ShopPanel/MarginContainer/VBoxContainer/Header/XPLabel
@onready var npc_dialog = $MainContainer/NPCPanel/MarginContainer/VBoxContainer/NPCDialog

var save_manager = preload("res://scripts/managers/save_manager.gd").new()

# Items temp
var shop_items = {
	"res://resources/items/bronze_ring.tres": 50,
	"res://resources/items/leather_bracelet.tres": 50,
	"res://resources/items/glass_necklace.tres": 50,
	"res://resources/items/silver_ring.tres": 150,
	"res://resources/items/artisan_gloves.tres": 150,
	"res://resources/items/sage_amulet.tres": 150,
	"res://resources/items/gold_ring.tres": 300,
	"res://resources/items/wind_boots.tres": 300,
	"res://resources/items/thinker_crown.tres": 300,
	"res://resources/items/perfection_medallion.tres": 1000
}

var npc_phrases = [
	"Bem-vindo à minha loja! Tenho os melhores itens da região!",
	"Ah, um cliente! Veja só essas maravilhas que tenho para oferecer!",
	"Itens raros e poderosos! Não vai se arrepender!",
	"Cada item aqui foi cuidadosamente selecionado!",
	"Fortaleça sua mente com meus itens especiais!",
	"XP bem gasto é XP investido em poder!"
]

func _ready():
	update_ui()
	show_random_phrase()

func update_ui():
	xp_label.text = "XP: %d" % State.save_data.get("experience", 0)
	
	for child in items_grid.get_children():
		child.queue_free()
	
	for item_path in shop_items.keys():
		var item = load(item_path)
		var price = shop_items[item_path]
		create_item_card(item, price)

func create_item_card(item: Item, price: int) -> VBoxContainer:
	var card = VBoxContainer.new()
	card.custom_minimum_size = Vector2(220, 0)
	
	var icon_container = PanelContainer.new()
	icon_container.custom_minimum_size = Vector2(200, 200)
	var icon = TextureRect.new()
	icon.texture = item.icon
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.set_anchors_preset(Control.PRESET_FULL_RECT)
	icon_container.add_child(icon)
	card.add_child(icon_container)
	
	var name_label = Label.new()
	name_label.text = item.name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 18)
	card.add_child(name_label)
	
	var bottom_container = HBoxContainer.new()
	bottom_container.add_theme_constant_override("separation", 10)
	
	var price_label = Label.new()
	price_label.text = "%d XP" % price
	price_label.add_theme_color_override("font_color", Color(1, 0.84, 0))
	price_label.add_theme_font_size_override("font_size", 20)
	price_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	price_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	bottom_container.add_child(price_label)
	
	var buy_button = Button.new()
	buy_button.text = "Comprar"
	buy_button.custom_minimum_size = Vector2(100, 35)
	buy_button.pressed.connect(_on_buy_pressed.bind(item, price))
	bottom_container.add_child(buy_button)
	
	card.add_child(bottom_container)
	
	items_grid.add_child(card)
	return card

func _on_buy_pressed(item: Item, price: int):
	var current_xp = State.save_data.get("experience", 0)
	
	if current_xp < price:
		npc_dialog.text = "XP insuficiente! Você precisa de %d XP." % (price - current_xp)
		return
	
	if State.inventory.items.size() >= State.inventory.max_inventory_space:
		npc_dialog.text = "Sua mochila está cheia! Libere espaço primeiro."
		return
	
	if State.inventory.items.has(item):
		npc_dialog.text = "Você já possui este item!"
		return
	
	State.save_data["experience"] -= price
	State.inventory.add_item(item)
	
	save_manager.save_game(State.save_path)
	
	npc_dialog.text = "Ótima escolha! %s é seu!" % item.name
	update_ui()

func show_random_phrase():
	npc_dialog.text = npc_phrases.pick_random()

func _on_close_pressed():
	FadeLayer.fade_to_scene("res://scenes/game/map.tscn")
