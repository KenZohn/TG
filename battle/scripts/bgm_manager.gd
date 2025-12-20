extends Node

@onready var player := AudioStreamPlayer.new()

var bgm_title = preload("res://assets/bgm/title_menu_maou_bgm_acoustic48.mp3")
var bgm_stage_select = preload("res://assets/bgm/stage_select_maou_bgm_acoustic36.mp3")

func _ready():
	add_child(player)
	player.bus = "Music"  # opcional: defina o bus

func play_bgm(stream: AudioStream):
	if stream == null:
		return
	# Se já está tocando essa mesma música, não reinicia
	if player.stream == stream and player.playing:
		return
	# Para qualquer música anterior
	player.volume_db = -5.0
	player.stop()
	
	stream.loop = true
	
	player.stream = stream
	player.play()

func stop_bgm():
	player.stop()

func fade_out(seconds: float = 1.0):
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -40.0, seconds)
	await tween.finished
	player.stop()
	player.volume_db = 0.0
