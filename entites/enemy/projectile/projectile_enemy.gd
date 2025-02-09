class_name ProjectileEnemy
extends CharacterBody3D

@onready var nav:NavigationAgent3D = $NavigationAgent3D
@onready var state_machine = $StateMachine

@export var damage:float
var player:Player
var can_damage_player:bool = true

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
	
func on_hit():
	state_machine.change_state($StateMachine/Stunned)
