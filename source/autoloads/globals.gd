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
var hug_zone = null
var hugSpeed = Vector2(3, 3)
var hugScore = 100.0
var difficultyLevel = 1 # This is used on the ships speed modifier
var difficultyLevelIncrement = 0.1
var difficultyScoreCount = 5 # Every 5 ships, the difficulty goes up
var ship_speed_modifier = 1 * difficultyLevel
var hugScoreDecayTickDelay = 0.8
var hugScoreDecayTickAmount = 1
var hugScoreDecayTickAmountInitial = 1
onready var whaleHugText = get_tree().get_root().get_node("main/hugWhaleText")
onready var hugMiniGamePromptText = get_tree().get_root().get_node("main/hugMiniGamePromptText")
onready var shipsHuggedCountTextField = get_tree().get_root().get_node("main/ShipsHuggedCount/Count")

var whaleTentaclesAttached = []
var shipHuggedCount = 0
var whaleShipWaitCount = 3
var whaleEnemy

#"Gravity"
var tentacle_correction_move_speed = Vector2(-5, 3)
# Ships variables
var max_number_of_ships_on_screen = 5

func set_hug_zone(hugZone):
	hug_zone = hugZone
func get_hug_zone():
	return(hug_zone)

func increase_difficulty_level(new_level):
	difficultyLevel = new_level # This is used on the ships speed modifier
	ship_speed_modifier = 1 * difficultyLevel

func set_tentacle_start_positions(start_left_pos:Vector2, end_left_pos:Vector2, start_right_pos:Vector2, end_right_pos:Vector2):
	initial_start_left_tentacle_position = start_left_pos
	initial_end_left_tentacle_position = end_left_pos
	initial_start_right_tentacle_position = start_right_pos
	initial_end_right_tentacle_position = end_right_pos
