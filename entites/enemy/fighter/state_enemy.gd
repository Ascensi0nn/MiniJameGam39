class_name EnemyState
extends Node

var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")

## Hold a reference to the parent so that it can be controlled by the state
var parent: Enemy

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process_input(_event: InputEvent) -> EnemyState:
	return null

func process_frame(_delta: float) -> EnemyState:
	return null

func process_physics(_delta: float) -> EnemyState:
	return null
