extends State

@export var walking_state: State
@export var jumping_state: State
@export var falling_state: State
@export var uppercutting_state: State

func enter() -> void:
	super()
	
func exit() -> void:
	super()

func process_input(event: InputEvent) -> State:
	if parent.can_uppercut and Input.is_action_just_pressed("uppercut"):
		return uppercutting_state
	if Input.is_action_just_pressed("jump"):
		return jumping_state
	if Input.is_action_just_released("sprint"):
		return walking_state

	parent.check_quit_game()
	parent.add_basic_camera_rotation(event)
	return null

func process_frame(_delta:float) -> State:
	parent.set_fov(85)
	return null

func process_physics(delta: float) -> State:
	if not parent.is_on_floor():
		return falling_state
	# movement
	parent.add_basic_velocity(parent.sprint_spd, parent.sprint_acc, parent.sprint_dec, delta)
		
	# gravity
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
		
	parent.move_and_slide()
	return null
