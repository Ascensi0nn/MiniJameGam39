extends Node

var player_score:int
var pirate_timer:Timer = Timer.new()
var pirate_speed:float

var player_max_health:int = 3
var player_current_health:int

func _ready():
	reset()
	
func reset():
	player_score = 0
	pirate_speed = 5.0
	player_current_health = player_max_health
	
	self.add_child(pirate_timer)
	pirate_timer.wait_time = 1
	pirate_timer.connect("timeout", add_pirate_speed)
	pirate_timer.start()
	# reset timer
	# reload scene

func add_pirate_speed() -> void:
	if pirate_speed >= 0.1:
		pirate_speed -= 0.1

func get_pirate_speed() -> float:
	return pirate_speed

func add_score() -> void:
	player_score += 1
	
func get_score() -> int:
	print(player_score)
	return player_score
	
func add_health() -> void:
	player_current_health = min(player_max_health, player_current_health + 1)
	
func reduce_health() -> void:
	player_current_health = max(0, player_current_health - 1)
	
func get_health() -> int:
	return player_current_health
