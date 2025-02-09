extends Node3D

@onready var hit_area:Area3D = $PunchArea
@onready var hit_sound:AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var hit_timer = $HitTimer
@onready var player = $".."

var can_attack:bool = true

func _input(_event:InputEvent):
	if Input.is_action_just_pressed("attack"):
		attack()

func attack() -> void:
	if not can_attack or not player.can_attack:
		return
	
	Trauma.on_player_attack()
	hit_sound.play()
	
	var speed = 10
	for collider in hit_area.get_overlapping_bodies():
		if collider is RigidBody3D:
			var body = collider as RigidBody3D
			var direction:Vector3 = body.global_position - player.global_position + Vector3(0, 1, 0)
			var distance = body.global_position.distance_to(player.global_position)
			
			body.apply_impulse(direction * speed / distance)
		elif collider.has_method("on_hit"):
			var body = collider as CharacterBody3D
			collider.on_hit()
			var direction:Vector3 = body.global_position - player.global_position + Vector3(0, 1, 0)
			var distance = body.global_position.distance_to(player.global_position)
			body.velocity = direction * speed / distance
	
	can_attack = false
	hit_timer.start()

func _on_attack_cooldown_timeout():
	can_attack = true
