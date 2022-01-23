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
var hugScore = 150.0 setget __hug_score_set, __hug_score_get
var hugScoreMax = 250.0
var hugScoreInitial = 200.0

#Difficulty settings:
var difficultyLevel = 1 # The overall difficulty level - this influences other difficulty variables
var difficultyLevelIncrement = 1 # every time we "go up a difficulty level" this is how much it increases by
var difficultyScoreCount = 5 # Every 5 ships, the difficulty goes up
var ship_speed_modifier = 1 # The ships' speed is multiplied by this
var ship_speed_modifier_increment = 1.2 # How much the ship speed modifier goes up every difficulty level
var hugScoreDecayTickDelay = 0.5 # How long it takes for the score to tick down
var hugScoreDecayTickAmount = 2 # How much it ticks down each time. 
var hugScoreDecayTickAmountIncrement = 0.5 # How much we incement the decay (amount) every time the difficulty goes up

#var hugMiniGamePromptText
var max_number_of_parrots_on_screen = 1
# Every 5 ships that are hugged, triggers a parrot. 
var parrotShipWaitCount = 5
var shipHuggedCount: int = 0 setget __ship_hugged_count_set, __ship_hugged_count_get

var water_height : float

#"Gravity"
var tentacle_correction_move_speed = Vector2(-5, 3)
# Ships variables
var max_number_of_ships_on_screen = 5

func set_hug_zone(hugZone):
	hug_zone = hugZone
func get_hug_zone():
	return(hug_zone)

func increase_difficulty_level():
	difficultyLevel = difficultyLevel + difficultyLevelIncrement
	ship_speed_modifier = ship_speed_modifier + ship_speed_modifier_increment
	hugScoreDecayTickAmount = hugScoreDecayTickAmount + hugScoreDecayTickAmountIncrement

func reset_difficulty_level():
	ship_speed_modifier = 1
	difficultyLevel = 1
	hugScoreDecayTickAmount = 2
	__ship_hugged_count_set(0)
	
	
func set_tentacle_start_positions(start_left_pos:Vector2, end_left_pos:Vector2, start_right_pos:Vector2, end_right_pos:Vector2):
	initial_start_left_tentacle_position = start_left_pos
	initial_end_left_tentacle_position = end_left_pos
	initial_start_right_tentacle_position = start_right_pos
	initial_end_right_tentacle_position = end_right_pos


func __hug_score_get() -> float:
	return hugScore


func __hug_score_set(value: float) -> void:
	hugScore = clamp(value, 0.0, hugScoreMax)
	Event.emit_signal("hug_update", hugScore, hugScoreMax)


func __ship_hugged_count_get() -> int:
	return shipHuggedCount


func __ship_hugged_count_set(value: int) -> void:
	shipHuggedCount = value

	Event.emit_signal("ship_update", shipHuggedCount)
