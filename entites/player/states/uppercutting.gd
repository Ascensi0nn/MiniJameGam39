extends State

@onready var uppercut_sound = $UppercutSound

@export var walk_state: State
@export var sprinting_state: State
@export var falling_state: State

func enter() -> void:
	super()
	parent.velocity.y = parent.uppercut_spd
	parent.can_uppercut = false
	parent.uppercut_timer.start()
	uppercut_sound.play()
	
func exit() -> void:
	super()

func process_input(event: InputEvent) -> State:
	parent.check_quit_game()
	parent.add_basic_camera_rotation(event)
	return null
	
func process_frame(_delta:float) -> State:
	parent.set_fov(75)
	return null

func process_physics(delta: float) -> State:
	if parent.is_on_floor():
		if Input.is_action_pressed("sprint"):
			return sprinting_state
		return walk_state
		
	if parent.velocity.y > 0.0:
		return falling_state
	
	parent.add_basic_velocity(parent.walk_spd, parent.walk_acc, parent.walk_dec, delta)
		
	# gravity
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
		
	parent.move_and_slide()
	return null
