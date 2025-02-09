extends State

@onready var ui = $Control

func enter() -> void:
	super()
	ui.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
func exit() -> void:
	super()
	ui.visible = false
	Engine.time_scale = 1

func process_input(_event: InputEvent) -> State:
	parent.check_quit_game()
	return null
	
func process_frame(_delta:float) -> State:
	parent.set_fov(10.0)
	Engine.time_scale = lerp(Engine.time_scale, 0.1, 0.01)
	return null

func process_physics(delta: float) -> State:
	parent.velocity = Vector3.ZERO
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
		
	parent.move_and_slide()
	return null
