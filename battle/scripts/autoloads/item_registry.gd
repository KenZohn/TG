extends Node

var _items: Dictionary = {}

func _ready():
	load_all_items_from_folder("res://resources/items/")

func load_all_items_from_folder(path: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				_register(path + file_name)
			file_name = dir.get_next()
	else:
		print("Erro: Não foi possível acessar a pasta de itens: ", path)

func _register(path: String):
	var item = load(path)
	if item is Item:
		_items[item.id] = item
		# Debug
		#print("Item registrado: ", item.id)

func get_item(id: String):
	if not _items.has(id):
		print("Aviso: Item ID não encontrado no Registry: ", id)
	return _items.get(id, null)
