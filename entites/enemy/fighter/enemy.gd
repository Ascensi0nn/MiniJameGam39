class_name Enemy
extends CharacterBody3D

@onready var nav:NavigationAgent3D = $NavigationAgent3D
@onready var state_machine = $StateMachine
@onready var anim_player:AnimationPlayer = $AnimationPlayer

@export var damage:float
var player:Player
var can_damage_player:bool = true

var gem1:PackedScene = preload("res://world_objects/other/GemBlue.tscn")
var gem2:PackedScene = preload("res://world_objects/other/GemGreen.tscn")
var gem3:PackedScene = preload("res://world_objects/other/GemPink.tscn")
var health:PackedScene = preload("res://world_objects/other/Health.tscn")
var pickup_arr = [gem1, gem2, gem3, health]

@export var walk_spd = 5
@export var walk_acc = 10

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	
func rotate_enemy_towards_velocity():
	var enemy_pos:Vector2 = Vector2(self.global_position.x, self.global_position.z)
	var rotation_vector = self.velocity + self.global_position
	var target_pos:Vector2 = Vector2(rotation_vector.x, rotation_vector.z)
	var direction:Vector2 = enemy_pos - target_pos
	self.rotation.y = lerp_angle(self.rotation.y, atan2(direction.x, direction.y), 0.2)
	
func rotate_enemy_towards_player():
	var enemy_pos:Vector2 = Vector2(self.global_position.x, self.global_position.z)
	var player_pos:Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var direction:Vector2 = enemy_pos - player_pos
	self.rotation.y = lerp_angle(self.rotation.y, atan2(direction.x, direction.y), 0.2)
	
func die():
	GameManager.add_score()
	# drop gem
	var pickup = pickup_arr[randi_range(0, len(pickup_arr) - 1)].instantiate()
	get_tree().get_root().add_child(pickup)
	pickup.global_position = self.global_position
	pickup.apply_impulse(10 * Vector3(0, 1, 0))
	
	# queue_free
	self.queue_free()
	
func on_hit():
	state_machine.change_state($StateMachine/Stunned)
