extends Node

@onready var background_music:AudioStreamWAV = preload("res://sounds/music/background_music.wav")
var music: AudioStreamPlayer = AudioStreamPlayer.new()


func _ready() -> void:
	add_child(music)
	music.stream = background_music
	music.play()
	music.connect("finished", loop)
	
	var tween = get_tree().create_tween()
	tween.tween_property(music, "volume_db", linear_to_db(1.0), 10.0).from(linear_to_db(0.1))

func loop() -> void:
	music.play()
