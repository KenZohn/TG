extends Node
class_name Inventory

var items: Array[Item] = []
var equipped_item = null
var max_inventory_space = 20

func add_item(item):
	items.append(item)

func equip_item(item):
	var index = items.find(item)
	if index == -1:
		return
	
	if equipped_item:
		items.append(equipped_item)
	
	equipped_item = item
	items.remove_at(index)  
	apply_bonus()

func unequip_item():
	if equipped_item:
		items.append(equipped_item)
		equipped_item = null
		apply_bonus()

func apply_bonus():
	State.player_health = State.save_data.get("player_health", 0)
	State.player_time = State.save_data.get("player_time", 0)
	State.player_damage = State.save_data.get("player_damage", 0)
	State.player_crit_chance = State.save_data.get("player_crit_chance", 0)
	State.player_defense = State.save_data.get("player_defense", 0)
	
	if equipped_item:
		State.player_health += equipped_item.memory_bonus
		State.player_time += equipped_item.agility_bonus
		State.player_damage += equipped_item.focus_bonus
		State.player_crit_chance += equipped_item.coordination_bonus
		State.player_defense += equipped_item.reasoning_bonus
	
	State.apply_player_state()

func serialize():
	return {
		"items": items.map(func(i): return i.id),
		"equipped": equipped_item.id if equipped_item else ""
	}

func deserialize(data):
	items.clear()
	equipped_item = null

	for id in data.get("items", []):
		var item = ItemRegistry.get_item(id)
		if item:
			items.append(item)

	var eq_id = data.get("equipped", "")
	if eq_id != "":
		equipped_item = ItemRegistry.get_item(eq_id)

	apply_bonus()
