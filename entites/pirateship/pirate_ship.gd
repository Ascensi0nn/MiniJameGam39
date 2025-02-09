extends Node3D

@onready var shot_timer = $ShotTimer
@onready var cannon_sound = $CannonShot

var player:Player
var markers:Array[Node3D]
var cannon_ball:PackedScene = preload("res://entites/pirateship/CannonBall.tscn")
var fighter_enemy:PackedScene = preload("res://entites/enemy/fighter/Enemy.tscn")
var projectile_enemy:PackedScene = preload("res://entites/enemy/projectile/ProjectileEnemy.tscn")
var enemy_arr = [fighter_enemy, projectile_enemy]

func _ready():
	shot_timer.wait_time *= randf_range(0.5, 1.5)
	shot_timer.start()
	
	for child in $Markers.get_children():
		markers.append(child)
		
	player = get_tree().get_first_node_in_group("Player")

func shoot_cannon():
	var marker_node:Node3D = markers[randi_range(0, len(markers) - 1)] as Marker3D
	
	# play sound
	cannon_sound.play()
	
	# shoot thing
	var cannon_position = marker_node.global_position
	var shot_direction = (player.global_position - cannon_position).normalized()
	var force = 75
	
	if randi_range(1, 3) == 1:
		var ball = cannon_ball.instantiate() as RigidBody3D
		get_tree().root.add_child(ball)
		ball.global_position = cannon_position
		ball.apply_impulse(shot_direction * force)
	else:
		var e = enemy_arr[randi_range(0, len(enemy_arr) - 1)].instantiate()
		get_tree().get_root().add_child(e)
		e.global_position = cannon_position
		e.velocity = shot_direction * force
	

func _on_shot_timer_timeout():
	shoot_cannon()
