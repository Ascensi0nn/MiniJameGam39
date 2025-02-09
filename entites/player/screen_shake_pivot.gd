extends Node3D

@export var trauma_reduction_rate:float = 1.0
@export var noise:FastNoiseLite
@export var noise_speed:float = 50.0
@export var max_x:float = 10.0
@export var max_y:float = 10.0
@export var max_z:float = 5.0

@onready var camera:Camera3D = %PlayerCamera
@onready var initial_rotation:Vector3 = camera.rotation_degrees

var trauma:float = 0.0
var time:float = 0.0

func _ready():
	Trauma.trauma_added.connect(add_trauma)

func _process(delta):
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	
	camera.rotation_degrees.x = initial_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0)
	camera.rotation_degrees.y = initial_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1)
	camera.rotation_degrees.z = initial_rotation.z + max_z * get_shake_intensity() * get_noise_from_seed(2)
	
func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_from_seed(_seed:int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)

func add_trauma(_pixelation_trauma:float, screen_shake_trauma:float):
	trauma += clamp(trauma + screen_shake_trauma, 0.0, 1.0)
