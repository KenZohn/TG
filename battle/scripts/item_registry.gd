extends Node

var _items: Dictionary = {}

func _ready():
	_register("res://resources/ring.tres")

func _register(path):
	var item = load(path)
	_items[item.id] = item

func get_item(id):
	return _items.get(id, null)
