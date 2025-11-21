extends Node

var hover_sound : AudioStream = preload("res://assets/se/maou_se_sound22.mp3")

func play():
	var player = AudioStreamPlayer.new()
	player.stream = hover_sound
	player.bus= "SFX"
	player.volume_db = -15   # diminui o volume em 10 dB
	add_child(player)
	player.play()
	player.connect("finished", Callable(player, "queue_free"))
