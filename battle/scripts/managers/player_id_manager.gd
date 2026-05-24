extends Node

var player_id: String = ""

func _ready():
	player_id = load_or_create_id()

func load_or_create_id() -> String:
	var path = "user://player_id.txt"
	
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var id = file.get_as_text().strip_edges()
		file.close()
		return id
	
	var new_id = "%d_%d" % [Time.get_unix_time_from_system(), randi()]
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(new_id)
	file.close()
	return new_id
