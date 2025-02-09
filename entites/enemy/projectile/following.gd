extends ProjectileEnemyState

var target_reached:bool = false
@export var shooting_state:ProjectileEnemyState

func enter() -> void:
	super()
	parent.can_damage_player = true
	target_reached = false
	
func exit() -> void:
	super()
	parent.nav.set_target_position(parent.global_position)

func process_frame(_delta:float) -> ProjectileEnemyState:
	if target_reached:
		return shooting_state
	return null

func process_physics(delta:float) -> ProjectileEnemyState:
	parent.nav.target_position = parent.player.global_position
	
	var direction = parent.nav.get_next_path_position() - parent.global_position
	direction = direction.normalized()
	
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	else:
		parent.velocity.x = lerp(parent.velocity.x, direction.x * parent.walk_spd, parent.walk_acc * delta)
		parent.velocity.z = lerp(parent.velocity.z, direction.z * parent.walk_spd, parent.walk_acc * delta)
	
	parent.move_and_slide()
	return null

func _on_navigation_agent_3d_target_reached():
	target_reached = true
