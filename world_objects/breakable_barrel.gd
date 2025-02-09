extends RigidBody3D

@onready var audio_player = $AudioStreamPlayer3D
@onready var mesh = $"Root Scene"
@onready var collision = $CollisionShape3D
@onready var particles = $GPUParticles3D
var gem1:PackedScene = preload("res://world_objects/other/GemBlue.tscn")
var gem2:PackedScene = preload("res://world_objects/other/GemGreen.tscn")
var gem3:PackedScene = preload("res://world_objects/other/GemPink.tscn")
var pickup_arr = [gem1, gem2, gem3]

func on_hit():
	mesh.queue_free()
	collision.queue_free()
	
	# sound
	audio_player.play()
	
	# drop item
	var pickup = pickup_arr[randi_range(0, len(pickup_arr) - 1)].instantiate()
	get_tree().current_scene.add_child(pickup)
	pickup.global_position = self.global_position
	pickup.apply_impulse(10 * Vector3(0, 1, 0))
	
	# particles
	particles.emitting = true
	
	
func _on_audio_stream_player_3d_finished():
	self.queue_free()
