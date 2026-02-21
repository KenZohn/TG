extends Control

@onready var equipped_icon = $Panel/MarginContainer/VBoxContainer/EquippedSection/EquippedSlot/ItemIcon
@onready var equipped_name = $Panel/MarginContainer/VBoxContainer/EquippedSection/EquippedName
@onready var unequip_button = $Panel/MarginContainer/VBoxContainer/EquippedSection/UnequipButton
@onready var items_grid = $Panel/MarginContainer/VBoxContainer/ScrollContainer/ItemsGrid
@onready var items_label = $Panel/MarginContainer/VBoxContainer/ItemsLabel

func _ready():
	load_test_ring()
	update_ui()

func update_ui():
	if State.inventory.equipped_item:
		var item = State.inventory.equipped_item
		equipped_name.text = item.name
		equipped_icon.texture = item.icon
		unequip_button.visible = true
	else:
		equipped_name.text = "Nenhum"
		equipped_icon.texture = null
		unequip_button.visible = false
	
	#items_label.text = "Itens (%d/20):" % State.inventory.items.size()
	
	for child in items_grid.get_children():
		child.queue_free()
	
	for i in range(20):
		var slot = create_item_slot(i)
		items_grid.add_child(slot)
		
func create_item_slot(index: int):
	var slot = Panel.new()
	slot.custom_minimum_size = Vector2(64, 64)
	
	if index < State.inventory.items.size():
		var item = State.inventory.items[index]
		
		var icon = TextureRect.new()
		icon.texture = item.icon
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.set_anchors_preset(Control.PRESET_FULL_RECT)
		slot.add_child(icon)
		
		var button = Button.new()
		button.set_anchors_preset(Control.PRESET_FULL_RECT)
		button.flat = true
		button.tooltip_text = "%s\n%s" % [item.name, item.description]
		button.pressed.connect(_on_item_pressed.bind(item))
		slot.add_child(button)
	
	return slot

func _on_item_pressed(item):
	State.inventory.equip_item(item)
	update_ui()

func _on_unequip_pressed():
	State.inventory.unequip_item()
	update_ui()

func _on_close_pressed():
	FadeLayer.fade_to_scene("res://scenes/map.tscn")
	
func load_test_ring():
	if not State.inventory.items:
		var anel = load("res://resources/ring.tres")
		State.inventory.add_item(anel)
