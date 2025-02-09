class_name Player
extends CharacterBody3D

@onready var state_machine = $StateMachine
@onready var camera_pivot = $CameraPivot
@onready var player_camera = %PlayerCamera
@onready var iframes_timer = $IFrames
@onready var uppercut_timer = $UppercutCooldown
@onready var hurt_audio = $HurtAudio

@export_category("Player Stats")
@export var walk_spd:float
@export var walk_acc:float
@export var walk_dec:float
@export var jump_spd:float
@export var sprint_spd:float
@export var sprint_acc:float
@export var sprint_dec:float
@export var uppercut_spd:float
@export_category("Other")
@export var camera_sens:float

var can_take_damage:bool = true
var can_uppercut:bool = true
var can_attack:bool = true

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)

# Inputs
func check_quit_game() -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
# Movement
func set_fov(angle:float) -> void:
	player_camera.fov = lerp(player_camera.fov, angle, 0.1)

func add_basic_camera_rotation(event) -> void:
	if event is InputEventMouseMotion:
		self.rotate_y(-event.relative.x * camera_sens)
		camera_pivot.rotate_x(-event.relative.y * camera_sens)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
func add_basic_velocity(spd:float, acc:float, dec:float, delta:float) -> void:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (camera_pivot.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if not is_on_floor():
		velocity.x = lerp(velocity.x, direction.x * spd, delta)
		velocity.z = lerp(velocity.z, direction.z * spd, delta)
		return
		
	velocity.x = lerp(velocity.x, direction.x * spd, delta * acc) if direction.x else lerp(velocity.x, direction.x * spd, delta * dec)
	velocity.z = lerp(velocity.z, direction.z * spd, delta * acc) if direction.y else lerp(velocity.z, direction.x * spd, delta * dec)

func take_damage():
	if not can_take_damage:
		return
	
	can_take_damage = false
	iframes_timer.start()
	
	GameManager.reduce_health()
	
	Trauma.on_player_damaged()
	hurt_audio.play()
	
	if GameManager.get_health() <= 0 and state_machine.current_state != $"StateMachine/Knocked Out" and state_machine.current_state != $"StateMachine/Dead":
		state_machine.change_state($"StateMachine/Knocked Out")

func _on_i_frames_timeout():
	can_take_damage = true

func _on_uppercut_cooldown_timeout():
	can_uppercut = true
