extends ColorRect

@export var starting_pixel_size:float = 4.0
@export var reduction_spd:float = 40.0

var trauma:float = 0.0

func _ready() -> void:
	Trauma.trauma_added.connect(add_trauma)

func _process(delta) -> void:
	trauma = max(trauma - delta * reduction_spd, 0)
	
	var effective_pixel_size = floor(trauma) if fmod(ceil(trauma), 2) else ceil(trauma)
	
	var mat = self.material as ShaderMaterial
	mat.set_shader_parameter('pixel_size', starting_pixel_size + effective_pixel_size)
	
func add_trauma(pixelation_trauma:float, _screen_shake_trauma:float):
	trauma += pixelation_trauma
