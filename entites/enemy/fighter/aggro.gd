extends EnemyState

func enter() -> void:
	super()
	parent.can_damage_player = true
	
	
func exit() -> void:
	super()
	parent.nav.set_target_position(parent.global_position)

func process_physics(delta:float) -> EnemyState:
	parent.nav.target_position = parent.player.global_position
	parent.rotate_enemy_towards_velocity()
	
	if not parent.anim_player.is_playing():
		parent.anim_player.play("Run")
	
	var direction = parent.nav.get_next_path_position() - parent.global_position
	direction = direction.normalized()
	
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	else:
		parent.velocity.x = lerp(parent.velocity.x, direction.x * parent.walk_spd, parent.walk_acc * delta)
		parent.velocity.z = lerp(parent.velocity.z, direction.z * parent.walk_spd, parent.walk_acc * delta)
	
	parent.move_and_slide()
	return null
