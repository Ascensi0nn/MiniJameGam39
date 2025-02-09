extends Node

signal trauma_added(pixelation_trauma, screen_shake_trauma)

func on_player_damaged():
	trauma_added.emit(60, 1.0)
	
func on_player_attack():
	trauma_added.emit(20, 0.5)
	
func on_player_ground_pound(last_vel:float):
	trauma_added.emit(abs(last_vel) * 2, 0.9)
