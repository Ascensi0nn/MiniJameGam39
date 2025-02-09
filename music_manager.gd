extends Node

@onready var background_music:AudioStreamWAV = preload("res://sounds/music/background_music.wav")

func _ready() -> void:
	var music: AudioStreamPlayer = AudioStreamPlayer.new()
	background_music.loop_mode = AudioStreamWAV.LOOP_FORWARD
	background_music.loop_end = background_music.data.size()
	add_child(music)
	music.stream = background_music
	music.play()
	
	var tween = get_tree().create_tween()
	tween.tween_property(music, "volume_db", linear_to_db(1.0), 10.0).from(linear_to_db(0.1))
