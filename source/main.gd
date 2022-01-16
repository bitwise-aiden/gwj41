extends Node2D

var Rope = preload("res://Parts/Rope.tscn")
var Ship = preload("res://Parts/Ship.tscn")
var ships = []
var start_pos := Vector2.ZERO
var end_pos := Vector2.ZERO
var ropes = []
var max_tentacles = 2
var tentacle_move_speed = Globals.tentacle_player_move_speed
var tentacle_correction_move_speed = Globals.tentacle_correction_move_speed

func _ready():
	spawn_tentacle(Globals.initial_start_left_tentacle_position, Globals.initial_end_left_tentacle_position)
	spawn_tentacle(Globals.initial_start_right_tentacle_position, Globals.initial_end_right_tentacle_position)
	spawn_ship(Vector2(Globals.projectResolution.x,100))
	
func spawn_tentacle(start_pos, end_pos):
	if len(ropes) < max_tentacles:
			var rope = Rope.instance()
			add_child(rope)
			rope.spawn_rope(start_pos, end_pos)
			start_pos = Vector2.ZERO
			end_pos = Vector2.ZERO
			ropes.append(rope)

func spawn_ship(start_pos):
	var ship = Ship.instance()
	add_child(ship)
	ships.append(ship)
	ship.global_position = start_pos
	
func _physics_process(delta):
	if len(ropes) > 1:
		#Control Left Tentacle:
		if Input.is_action_pressed("leftTentacleGoUp") and (ropes[0].getRopeEndPoint().y + tentacle_move_speed.y >= Globals.tentacle_height_cap):
			ropes[0].setRopeEndPoint(Vector2(ropes[0].getRopeEndPoint().x, ropes[0].getRopeEndPoint().y + tentacle_move_speed.y))
		else:
			if ropes[0].getRopeEndPoint().y < Globals.initial_end_left_tentacle_position.y:
				ropes[0].setRopeEndPoint(Vector2(ropes[0].getRopeEndPoint().x, ropes[0].getRopeEndPoint().y + tentacle_correction_move_speed.y))

		if Input.is_action_pressed("leftTentacleGoRight") and (ropes[0].getRopeEndPoint().x + tentacle_move_speed.x <= Globals.tentacle_width_cap):
			ropes[0].setRopeEndPoint(Vector2(ropes[0].getRopeEndPoint().x + tentacle_move_speed.x, ropes[0].getRopeEndPoint().y ))
		else:
			if ropes[0].getRopeEndPoint().x > Globals.initial_end_left_tentacle_position.x:
				ropes[0].setRopeEndPoint(Vector2(ropes[0].getRopeEndPoint().x + tentacle_correction_move_speed.x, ropes[0].getRopeEndPoint().y))
		
		#Control Right Tentacle:
		if Input.is_action_pressed("rightTentacleGoUp") and (ropes[1].getRopeEndPoint().y + tentacle_move_speed.y >= Globals.tentacle_height_cap):
			ropes[1].setRopeEndPoint(Vector2(ropes[1].getRopeEndPoint().x, ropes[1].getRopeEndPoint().y + tentacle_move_speed.y))
		else:
			if ropes[1].getRopeEndPoint().y < Globals.initial_end_right_tentacle_position.y:
				ropes[1].setRopeEndPoint(Vector2(ropes[1].getRopeEndPoint().x, ropes[1].getRopeEndPoint().y + tentacle_correction_move_speed.y))
		
		if Input.is_action_pressed("rightTentacleGoLeft") and (ropes[1].getRopeEndPoint().x - tentacle_move_speed.x >= 0):
			ropes[1].setRopeEndPoint(Vector2(ropes[1].getRopeEndPoint().x - tentacle_move_speed.x, ropes[1].getRopeEndPoint().y ))
		else:
			if ropes[1].getRopeEndPoint().x < Globals.initial_end_right_tentacle_position.x:
				ropes[1].setRopeEndPoint(Vector2(ropes[1].getRopeEndPoint().x - tentacle_correction_move_speed.x, ropes[1].getRopeEndPoint().y))
				
				
	if (len(get_tree().get_nodes_in_group("ships")) < Globals.max_number_of_ships_on_screen):
		spawn_ship(Vector2(Globals.projectResolution.x,100))
	#Globals.max_number_of_ships_on_screen
	#Globals.max_number_of_ships_on_screen
