extends Control

@onready var button_retry = $HBoxContainer/Retry
@onready var button_menu = $HBoxContainer/Menu

func _process(_delta):
	$FinalScore.text = "Final Score: " + str(GameManager.get_score())

func _on_retry_pressed():
	GameManager.reset()

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://worlds/Menu.tscn")
	GameManager.clear_scene()
	
