extends State

@onready var target_rotation = Vector3(0.0, 0.0, 90.0)
@onready var ko_timer = $"KO Timer"
@onready var ko_audio = $AudioStreamPlayer3D
var timer_elapsed:bool = false

@export var dead_state:State

func enter() -> void:
	super()
	timer_elapsed = false
	ko_timer.start()
	parent.can_attack = false
	
func exit() -> void:
	super()
	parent.can_attack = true

func process_input(event: InputEvent) -> State:
	parent.check_quit_game()
	parent.add_basic_camera_rotation(event)
	return null
	
func process_frame(_delta:float) -> State:
	if timer_elapsed:
		return dead_state
		
	parent.set_fov(100.0)
	return null

func process_physics(delta: float) -> State:
	parent.velocity = Vector3.ZERO
	
	parent.rotation_degrees = lerp(parent.rotation_degrees, target_rotation, 0.05)
	
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
		
	parent.move_and_slide()
	return null

func _on_ko_timer_timeout():
	print('hehehehhaw')
	timer_elapsed = true
