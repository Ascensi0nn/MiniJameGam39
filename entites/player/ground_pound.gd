extends Node3D

@export var limit:float = -10.0
@onready var gp_area:Area3D = $GPArea
@onready var light_particles:GPUParticles3D = $LightParticles
@onready var dark_particles:GPUParticles3D = $DarkParticles
@onready var audio = $AudioStreamPlayer3D
var player:Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _on_falling_hit_the_ground(is_on_ground:bool, last_velocity:float):
	if is_on_ground and last_velocity <= limit:
		ground_pound(-last_velocity)

func ground_pound(last_velocity:float):
	light_particles.emitting = true
	dark_particles.emitting = true
	Trauma.on_player_ground_pound(last_velocity)
	audio.play()
	
	for collider in gp_area.get_overlapping_bodies():
		if collider is RigidBody3D:
			var body = collider as RigidBody3D
			var direction:Vector3 = body.global_position - gp_area.global_position
			var distance = body.global_position.distance_to(gp_area.global_position)
		
			direction = Vector3(direction.x, direction.y * 5, direction.z)
			body.apply_impulse(direction * last_velocity / distance)
			
		elif collider.has_method("on_hit"):
			var body = collider as CharacterBody3D
			collider.on_hit()
			var direction:Vector3 = body.global_position - player.global_position + Vector3(0, 1, 0)
			direction = Vector3(direction.x, 2 * direction.y, direction.z)
			var distance = body.global_position.distance_to(player.global_position)
			body.velocity = direction * 20 / distance
		
