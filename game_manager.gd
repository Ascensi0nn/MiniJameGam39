extends Node

var player_score:int
var pirate_timer:Timer = Timer.new()
var pirate_speed:float

var player_max_health:int = 3
var player_current_health:int

func _ready():
	player_score = 0
	pirate_speed = 5.0
	player_current_health = player_max_health
	
	await get_tree().create_timer(1).timeout
	
	self.add_child(pirate_timer)
	pirate_timer.wait_time = 1
	pirate_timer.connect("timeout", add_pirate_speed)
	pirate_timer.start()
	
func reset():
	clear_scene()
	get_tree().reload_current_scene()
	
func clear_scene():
	Engine.time_scale = 1
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.get_parent().remove_child(enemy)
		enemy.queue_free()
	
	for projectile in get_tree().get_nodes_in_group("Projectile"):
		projectile.get_parent().remove_child(projectile)
		projectile.queue_free()
		
	for pickup in get_tree().get_nodes_in_group("Pickup"):
		pickup.get_parent().remove_child(pickup)
		pickup.queue_free()
		
	for player in get_tree().get_nodes_in_group("Player"):
		player.get_parent().remove_child(player)
		player.queue_free()
		
	player_score = 0
	pirate_speed = 5.0
	player_current_health = player_max_health
	
	await get_tree().create_timer(1).timeout
	pirate_timer.start()

func add_pirate_speed() -> void:
	if pirate_speed >= 0.1:
		pirate_speed -= 0.1

func get_pirate_speed() -> float:
	return pirate_speed

func add_score() -> void:
	player_score += 1
	
func get_score() -> int:
	return player_score
	
func add_health() -> void:
	player_current_health = min(player_max_health, player_current_health + 1)
	
func reduce_health() -> void:
	player_current_health = max(0, player_current_health - 1)
	
func get_health() -> int:
	return player_current_health
