extends RigidBody3D

@onready var explosion_area = $ExplosionArea
var can_explode:bool = true

func explode() -> void:
	if not can_explode:
		return
	can_explode = false
		
	# play particles and sound
	var node = $Node3D
	
	node.get_parent().remove_child(node)
	get_tree().root.add_child(node)
	node.global_position = self.global_position
	
	for child in node.get_children():
		if child is GPUParticles3D:
			var particle = child as GPUParticles3D
			particle.emitting = true
		elif child is AudioStreamPlayer3D:
			var audio = child as AudioStreamPlayer3D
			audio.play()
		
	# knockback area
	var speed = 10
	for collider in explosion_area.get_overlapping_bodies():
		if collider is RigidBody3D:
			var body = collider as RigidBody3D
			var direction:Vector3 = body.global_position - explosion_area.global_position
			body.apply_impulse(direction * speed)
			
		if collider.has_method("on_hit"):
			var body = collider as CharacterBody3D
			collider.on_hit()
			var direction:Vector3 = body.global_position - explosion_area.global_position
			var distance = body.global_position.distance_to(explosion_area.global_position)
			body.velocity = direction * speed / distance
		
		if collider.has_method("take_damage"):
			collider.take_damage()
	
	self.queue_free()

func _on_area_3d_body_entered(body):
	if body is StaticBody3D:
		explode()
