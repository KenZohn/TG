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
	State.memory = State.save_data.get("memory", 0)
	State.agility = State.save_data.get("agility", 0)
	State.focus = State.save_data.get("focus", 0)
	State.reasoning = State.save_data.get("reasoning", 0)
	State.coordination = State.save_data.get("coordination", 0)
	
	if equipped_item:
		State.memory += equipped_item.memory_bonus
		State.agility += equipped_item.agility_bonus
		State.focus += equipped_item.focus_bonus
		State.reasoning += equipped_item.reasoning_bonus
		State.coordination += equipped_item.coordination_bonus
