extends Node


# Time globals
# Current rate of time passing.
#	1.0 is default
#	< 1.0 is slowed down
#	> 1.0 is speed up
var time_modifier: float = 1.0

# Screen globals
var projectResolution= OS.get_window_size()

# Tentacle based globals (Player movement)
var initial_start_left_tentacle_position = Vector2(500,700)
var initial_end_left_tentacle_position = Vector2(300,400)
var initial_start_right_tentacle_position = Vector2(1000,700)
var initial_end_right_tentacle_position = Vector2(1100, 400)
var tentacle_player_move_speed = Vector2(20, -20)
var tentacle_height_cap = 10
var tentacle_width_cap = projectResolution.x

#"Gravity"
var tentacle_correction_move_speed = Vector2(-5, 3)

<<<<<<< HEAD
# Ships variables
var max_number_of_ships_on_screen = 2

func set_tentacle_start_positions(start_left_pos:Vector2, end_left_pos:Vector2, start_right_pos:Vector2, end_right_pos:Vector2):
	initial_start_left_tentacle_position = start_left_pos
	initial_end_left_tentacle_position = end_left_pos
	initial_start_right_tentacle_position = start_right_pos
	initial_end_right_tentacle_position = end_right_pos
=======
>>>>>>> origin/main
