extends Area3D

@onready var anim_player:AnimationPlayer = $"../AnimationPlayer"

var player_in_body:bool = false
var player:Player
var enemy:Enemy

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	enemy = $".."

func _process(_delta) -> void:
	if enemy.can_damage_player and player_in_body:
		anim_player.stop()
		anim_player.play("Attack")
		player.take_damage()

func _on_body_entered(body):
	if body is Player:
		player_in_body = true

func _on_body_exited(body):
	if body is Player:
		player_in_body = false
