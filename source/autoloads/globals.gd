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
var initial_start_left_tentacle_position = Vector2(550,700)
var initial_end_left_tentacle_position = Vector2(300,400)
var initial_start_right_tentacle_position = Vector2(1280-550,700)
var initial_end_right_tentacle_position = Vector2(1280-300, 400)
var tentacle_player_move_speed = Vector2(20, -20)
var tentacle_height_cap = 10
var tentacle_width_cap = projectResolution.x
var ship_speed_modifier = 1
var hug_zone = null
var hugSpeed = Vector2(3, 3)
var hugScore = 100.0
var hugScoreDecayTickDelay = 0.5
var hugScoreDecayTickAmount = 1
onready var hugScoreTextField = get_tree().get_root().get_node("main/HugScore/Score")

#"Gravity"
var tentacle_correction_move_speed = Vector2(-5, 3)

# Ships variables
var max_number_of_ships_on_screen = 2

func set_hug_zone(hugZone):
	hug_zone = hugZone
func get_hug_zone():
	return(hug_zone)

func set_tentacle_start_positions(start_left_pos:Vector2, end_left_pos:Vector2, start_right_pos:Vector2, end_right_pos:Vector2):
	initial_start_left_tentacle_position = start_left_pos
	initial_end_left_tentacle_position = end_left_pos
	initial_start_right_tentacle_position = start_right_pos
	initial_end_right_tentacle_position = end_right_pos
