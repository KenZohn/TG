extends Node

var click_sound : AudioStream = preload("res://assets/se/maou_se_system48.mp3")

func play():
	var player = AudioStreamPlayer.new()
	player.stream = click_sound
	player.bus= "SFX"
	player.volume_db = -10   # diminui o volume em 10 dB
	add_child(player)
	player.play()
	player.connect("finished", Callable(player, "queue_free"))
