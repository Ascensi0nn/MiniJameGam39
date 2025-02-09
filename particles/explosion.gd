extends Node3D

var audio_played:bool = false

func _on_smoke_finished():
	if audio_played:
		self.queue_free()

func _on_audio_stream_player_3d_finished():
	audio_played = true
