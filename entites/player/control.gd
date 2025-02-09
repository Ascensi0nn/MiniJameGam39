extends Control

@onready var button_retry = $HBoxContainer/Retry
@onready var button_menu = $HBoxContainer/Menu

func _on_retry_pressed():
	GameManager.reset()

func _on_menu_pressed():
	GameManager.clear_scene()
	get_tree().change_scene_to_file("res://worlds/Menu.tscn")
