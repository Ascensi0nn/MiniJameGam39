extends ProjectileEnemyState

@onready var timer = $Timer
var timeout:bool = false
var random_rotation:Vector3

@export var following_state:ProjectileEnemyState

func enter() -> void:
	super()
	timeout = false
	timer.wait_time = randi_range(1, 4)
	timer.start()
	parent.nav.set_target_position(parent.global_position)
	parent.anim_player.stop()
	parent.anim_player.play("Death")
	
func exit() -> void:
	super()
	parent.rotation_degrees = Vector3.ZERO
	parent.anim_player.stop()
	parent.anim_player.play_backwards("Death")
	
func process_frame(_delta:float) -> ProjectileEnemyState:
	if timeout:
		return following_state
	return null

func process_physics(delta:float) -> ProjectileEnemyState:	
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
