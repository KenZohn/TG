extends Node

var config = ConfigFile.new()

func load_settings():
	var err = config.load("user://settings.cfg")
	if err == OK:
		if config.has_section_key("audio", "music_volume"):
			var music_bus = AudioServer.get_bus_index("Music")
			var vol = config.get_value("audio", "music_volume")
			AudioServer.set_bus_volume_db(music_bus, vol)
			AudioServer.set_bus_mute(music_bus, vol == -30)

		if config.has_section_key("audio", "sfx_volume"):
			var sfx_bus = AudioServer.get_bus_index("SFX")
			var vol = config.get_value("audio", "sfx_volume")
			AudioServer.set_bus_volume_db(sfx_bus, vol)
			AudioServer.set_bus_mute(sfx_bus, vol == -30)

func save_settings(music_vol: float, sfx_vol: float):
	config.set_value("audio", "music_volume", music_vol)
	config.set_value("audio", "sfx_volume", sfx_vol)
	config.save("user://settings.cfg")
