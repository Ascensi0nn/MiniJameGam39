class_name ProjectileEnemyState
extends Node

var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")

## Hold a reference to the parent so that it can be controlled by the state
var parent: ProjectileEnemy

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process_input(_event: InputEvent) -> ProjectileEnemyState:
	return null

func process_frame(_delta: float) -> ProjectileEnemyState:
	return null

func process_physics(_delta: float) -> ProjectileEnemyState:
	return null
