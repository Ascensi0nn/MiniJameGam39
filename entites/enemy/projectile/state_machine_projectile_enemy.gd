extends Node
 
@export var starting_state: ProjectileEnemyState
var current_state: ProjectileEnemyState

func init(parent: ProjectileEnemy) -> void:
	for child in get_children():
		child.parent = parent
	change_state(starting_state)

func change_state(new_state: ProjectileEnemyState) -> void:
	if current_state == new_state:
		return
	
	if current_state:
		current_state.exit()
		
	current_state = new_state
	current_state.enter()
	
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
		
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
		
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
