extends EnemyState

@onready var timer = $Timer
var timeout:bool = false
var random_rotation:Vector3

@export var aggro_state:EnemyState

func enter() -> void:
	super()
	random_rotation.x = 90
	random_rotation.z = randi_range(0, 180)
	timeout = false
	timer.wait_time = randi_range(1, 4)
	timer.start()
	parent.can_damage_player = false
	parent.nav.set_target_position(parent.global_position)
	
func exit() -> void:
	super()
	parent.rotation_degrees = Vector3.ZERO
	
func process_frame(_delta:float) -> EnemyState:
	if timeout:
		return aggro_state
	return null

func process_physics(delta:float) -> EnemyState:
	parent.rotation_degrees = lerp(parent.rotation_degrees, random_rotation, 0.1)
	
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	else:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, 0.05)
		parent.velocity.z = lerp(parent.velocity.z, 0.0, 0.05)

		
	parent.move_and_slide()
	return null

func _on_timer_timeout():
	timeout = true
	timer.stop()
