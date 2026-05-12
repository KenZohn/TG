extends Control

@onready var equipped_icon = $Panel/MarginContainer/VBoxContainer/EquippedSection/EquippedSlot/ItemIcon
@onready var equipped_name = $Panel/MarginContainer/VBoxContainer/EquippedSection/EquippedName
@onready var unequip_button = $Panel/MarginContainer/VBoxContainer/EquippedSection/UnequipButton
@onready var items_grid = $Panel/MarginContainer/VBoxContainer/ScrollContainer/ItemsGrid
@onready var items_label = $Panel/MarginContainer/VBoxContainer/ItemsLabel

var slots: Array = []

var style_empty = StyleBoxFlat.new()
var style_filled = StyleBoxFlat.new()
var style_equipped_slot = StyleBoxFlat.new()

func _ready():
    _setup_styles()
    _create_slots()
    _setup_equipped_slot()
    update_ui()

func _setup_styles():
    style_empty.bg_color = Color(0.12, 0.12, 0.12, 1)
    style_empty.border_width_left = 2
    style_empty.border_width_top = 2
    style_empty.border_width_right = 2
    style_empty.border_width_bottom = 2
    style_empty.border_color = Color(0.3, 0.3, 0.3, 0.8)
    style_empty.corner_radius_top_left = 4
    style_empty.corner_radius_top_right = 4
    style_empty.corner_radius_bottom_right = 4
    style_empty.corner_radius_bottom_left = 4

    style_filled.bg_color = Color(0.15, 0.2, 0.25, 1)
    style_filled.border_width_left = 2
    style_filled.border_width_top = 2
    style_filled.border_width_right = 2
    style_filled.border_width_bottom = 2
    style_filled.border_color = Color(0.4, 0.6, 0.8, 0.9)
    style_filled.corner_radius_top_left = 4
    style_filled.corner_radius_top_right = 4
    style_filled.corner_radius_bottom_right = 4
    style_filled.corner_radius_bottom_left = 4

    style_equipped_slot.bg_color = Color(0.15, 0.2, 0.15, 1)
    style_equipped_slot.border_width_left = 2
    style_equipped_slot.border_width_top = 2
    style_equipped_slot.border_width_right = 2
    style_equipped_slot.border_width_bottom = 2
    style_equipped_slot.border_color = Color(0.4, 0.8, 0.4, 0.9)
    style_equipped_slot.corner_radius_top_left = 4
    style_equipped_slot.corner_radius_top_right = 4
    style_equipped_slot.corner_radius_bottom_right = 4
    style_equipped_slot.corner_radius_bottom_left = 4

func _setup_equipped_slot():
    var equipped_slot = $Panel/MarginContainer/VBoxContainer/EquippedSection/EquippedSlot
    equipped_slot.add_theme_stylebox_override("panel", style_equipped_slot)

func _create_slots():
    for i in range(20):
        var slot = Panel.new()
        slot.custom_minimum_size = Vector2(64, 64)
        slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL 
        slot.add_theme_stylebox_override("panel", style_empty)
        items_grid.add_child(slot)
        slots.append(slot)

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

    items_label.text = "Itens (%d/20):" % State.inventory.items.size()

    for i in range(slots.size()):
        var slot = slots[i]
        for child in slot.get_children():
            child.queue_free()

        if i < State.inventory.items.size():
            var item = State.inventory.items[i]
            slot.add_theme_stylebox_override("panel", style_filled)

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
        else:
            slot.add_theme_stylebox_override("panel", style_empty)

func _on_item_pressed(item):
    State.inventory.equip_item(item)
    update_ui()

func _on_unequip_pressed():
    State.inventory.unequip_item()
    update_ui()

func _on_close_pressed():
    FadeLayer.fade_to_scene("res://scenes/game/map.tscn")

