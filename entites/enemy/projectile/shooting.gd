extends ProjectileEnemyState

@onready var timer = $Timer
var can_shoot:bool = false
var times_shot:int
var cannon_ball:PackedScene = preload("res://entites/pirateship/Bomb.tscn")

@export var following_state:ProjectileEnemyState

func enter() -> void:
	super()
	parent.nav.set_target_position(parent.global_position)
	parent.velocity = Vector3.ZERO
	times_shot = 0
	timer.start()
	can_shoot = false
	
func exit() -> void:
	super()
	parent.rotation_degrees = Vector3.ZERO
	
func process_frame(_delta:float) -> ProjectileEnemyState:
	if times_shot == 3:
		return following_state
	return null

func process_physics(delta:float) -> ProjectileEnemyState:
	parent.rotate_enemy_towards_player()
	
	if can_shoot:
		var ball = cannon_ball.instantiate()
		get_tree().root.add_child(ball)
		ball.global_position = parent.global_position
		
		var shot_direction = (parent.player.global_position - parent.global_position).normalized()
		var shot_distance = parent.global_position.distance_to(parent.player.global_position)
		ball.apply_impulse(shot_direction * 1.5 * shot_distance)
		
		can_shoot = false
		times_shot += 1
		
		parent.anim_player.play("Throw")
	
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
		
	parent.move_and_slide()
	return null
	
func _on_timer_timeout():
	can_shoot = true
