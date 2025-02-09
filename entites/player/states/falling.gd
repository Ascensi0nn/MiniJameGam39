extends State

@export var walk_state: State
@export var sprinting_state: State
@export var uppercutting_state: State

var last_velocity:float
signal hit_the_ground(is_on_ground_bool, last_velocity:float)

func enter() -> void:
	super()
	
func exit() -> void:
	super()
	hit_the_ground.emit(parent.is_on_floor(), last_velocity)

func process_input(event: InputEvent) -> State:
	parent.check_quit_game()
	parent.add_basic_camera_rotation(event)
	
	if parent.can_uppercut and Input.is_action_just_pressed("uppercut"):
		return uppercutting_state
	return null
	
func process_frame(_delta:float) -> State:
	parent.set_fov(75)
	return null

func process_physics(delta: float) -> State:
	if parent.is_on_floor():
		if Input.is_action_pressed("sprint"):
			return sprinting_state
		return walk_state
	
	last_velocity = parent.velocity.y
	parent.add_basic_velocity(parent.walk_spd, parent.walk_acc, parent.walk_dec, delta)
	
	# gravity
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	
	parent.move_and_slide()
	return null
