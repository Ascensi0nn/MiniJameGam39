extends RigidBody3D
@export_enum("HEALTH", "GEM") var type:String

func _on_area_3d_body_entered(body):
	if body is Player:
		if type == "HEALTH":
			GameManager.add_health()
		elif type == "GEM":
			GameManager.add_score()
		else:
			print('oopsies')
		$"Root Scene".queue_free()
		$CollisionShape3D.queue_free()
		$AudioStreamPlayer3D.play()

func _on_audio_stream_player_3d_finished():
	self.queue_free()
