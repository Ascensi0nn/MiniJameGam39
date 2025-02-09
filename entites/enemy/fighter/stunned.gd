extends EnemyState

@onready var timer = $Timer
var timeout:bool = false

@export var aggro_state:EnemyState

func enter() -> void:
	super()
	timeout = false
	timer.wait_time = randf_range(1, 4)
	timer.start()
	parent.can_damage_player = false
	parent.nav.set_target_position(parent.global_position)
	parent.anim_player.stop()
	parent.anim_player.play("Stunned")
	
func exit() -> void:
	super()
	parent.rotation_degrees = Vector3.ZERO
	parent.anim_player.stop()
	parent.anim_player.play_backwards("Stunned")
	
func process_frame(_delta:float) -> EnemyState:
	if timeout:
		if randi_range(1, 2) == 1:
			parent.die()
			return null
		return aggro_state
	return null

func process_physics(delta:float) -> EnemyState:	
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
