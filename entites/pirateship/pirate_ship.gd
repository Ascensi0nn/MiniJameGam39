extends Node3D

@onready var shot_timer = $ShotTimer
@onready var cannon_sound:AudioStreamMP3 = preload("res://sounds/pirate_ship/cannon.mp3")

var player:Player
var markers:Array[Node3D]
var cannon_ball:PackedScene = preload("res://entites/pirateship/CannonBall.tscn")
var fighter_enemy:PackedScene = preload("res://entites/enemy/fighter/Enemy.tscn")
var projectile_enemy:PackedScene = preload("res://entites/enemy/projectile/ProjectileEnemy.tscn")
var barrel:PackedScene = preload("res://world_objects/BreakableBarrel.tscn")
var arr = [fighter_enemy, projectile_enemy, barrel, cannon_ball]

func _ready():
	shot_timer.start()
	shot_timer.wait_time = GameManager.get_pirate_speed()
	
	for child in $Markers.get_children():
		markers.append(child)
		
	player = get_tree().get_first_node_in_group("Player")

func shoot_cannon():
	var marker_node:Node3D = markers[randi_range(0, len(markers) - 1)] as Marker3D
	
	# play sound
	var sound: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(sound)
	sound.stream = cannon_sound
	sound.play()
	
	# shoot thing
	var cannon_position = marker_node.global_position
	var shot_direction = (player.global_position - cannon_position).normalized()
	var force = 75
	
	var object = arr[randi_range(0, len(arr) - 1)].instantiate()
	if object is RigidBody3D:
		get_tree().current_scene.add_child(object)
		object.global_position = cannon_position
		object.apply_impulse(shot_direction * force)
	elif object is CharacterBody3D:
		get_tree().current_scene.add_child(object)
		object.global_position = cannon_position
		object.velocity = shot_direction * force
	

func _on_shot_timer_timeout():
	shoot_cannon()
	shot_timer.wait_time = max(1.0, GameManager.pirate_speed)
