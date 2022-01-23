extends Node2D # Will this break things? \n\r\l """ - TheoremMetal

var Rope = preload("res://Parts/Rope.tscn")
var Ship = preload("res://Parts/Ship.tscn")
var Parrot = preload("res://Parts/Parrot.tscn")
var Broken_Ship = preload("res://Parts/Broken_Ship.tscn")
var parrots = []
var ships = []
var start_pos := Vector2.ZERO
var end_pos := Vector2.ZERO
var parrotSpawnPos = Vector2(-100,100)
var ropes = []
var max_tentacles = 6
var tentacle_move_speed = Globals.tentacle_player_move_speed
var tentacle_correction_move_speed = Globals.tentacle_correction_move_speed
var left_tentacle
var right_tentacle
var decorative_tentacles = []
var decorative_tentacles_offset_multiplier = Vector2(200,-30)
var decorative_tentacles_initial_positions = [Vector2(Globals.initial_end_left_tentacle_position.x - 100,480), \
Vector2(Globals.initial_end_left_tentacle_position.x - 150,560), \
Vector2(Globals.initial_end_right_tentacle_position.x + 100,480), \
Vector2(Globals.initial_end_right_tentacle_position.x + 150,560)]

var time_start = 0
var time_now = 0
	# Spawn two broken halves of the ship
	# spawn a ghost ship
func kill_parrot(parrot):
	parrots.remove(parrots.find(parrot))

func _ready():
	randomize()
	Globals.hugMiniGamePromptText = $hugMiniGamePromptText
	Event.connect("emit_ship_death", self, "kill_ship")
	Event.connect("emit_parrot_death", self, "kill_parrot")
	Event.connect("spawn_parrot", self, "spawn_parrot")
	Event.connect("spawn_new_broken_ship", self, "make_broken_ship")
	left_tentacle = spawn_tentacle(Globals.initial_start_left_tentacle_position, Globals.initial_end_left_tentacle_position)
	right_tentacle = spawn_tentacle(Globals.initial_start_right_tentacle_position, Globals.initial_end_right_tentacle_position)
	Event.emit_signal("emit_audio", {"type": "music", "name": "background"})
	spawn_ship(Vector2(Globals.projectResolution.x, 180))
	time_start = OS.get_unix_time()
	Transition.fade_in()
	Globals.hugScore = Globals.hugScoreInitial

func kill_ship(ship):
	ships.remove(ships.find(ship))

func make_broken_ship(ship):
	var BS = Broken_Ship.instance()
	add_child(BS)
	BS.leftHalf.global_position = ropes[0].getRopeEndPoint()
	BS.rightHalf.global_position = ropes[1].getRopeEndPoint()

func spawn_tentacle(start_pos, end_pos):
	if len(ropes) <= max_tentacles:
			var rope = Rope.instance()
			add_child(rope)
			rope.spawn_rope(start_pos, end_pos)
			start_pos = Vector2.ZERO
			end_pos = Vector2.ZERO
			ropes.append(rope)
			return(rope)

func spawn_ship(start_pos):
	var ship = Ship.instance()
	ships.append(ship)
	ship.global_position = start_pos
	add_child(ship)

func spawn_parrot():
	var parrot = Parrot.instance()
	parrots.append(parrot)
	parrot.global_position = parrotSpawnPos
	add_child(parrot)

func reset_decorative_tentacles_positions():
	for i in range(len(ropes)):
		ropes[i].setRopeEndPoint(decorative_tentacles_initial_positions[i])

func _physics_process(delta):
	if Globals.hugScore <= 0:
		print("Game Over. Score: ", Globals.shipHuggedCount)

	if Globals.hugScore <= 0:
		time_now = OS.get_unix_time()
		var time_elapsed = time_now - time_start
		Event.emit_signal("game_over")

	if left_tentacle.get_mast_attached() != null: # "Hug score, hug score, tentacle, rope..." What are you talking about Velop? - Lil'Oni
		ropes[0].setRopeEndPoint(Vector2(left_tentacle.get_mast_attached().global_position.x, left_tentacle.get_mast_attached().global_position.y))
	if right_tentacle.get_mast_attached() != null:
		ropes[1].setRopeEndPoint(Vector2(right_tentacle.get_mast_attached().global_position.x, right_tentacle.get_mast_attached().global_position.y))

	if len(ropes) > 1:

		if Input.is_action_pressed("leftTentacleGoUp") and \
		(ropes[0].getRopeEndPoint().y + tentacle_move_speed.y >= Globals.tentacle_height_cap) and \
		ropes[0].shipMastAttachedTo == null:
			ropes[0].setRopeEndPoint(Vector2(ropes[0].getRopeEndPoint().x - (tentacle_move_speed.x * 2), ropes[0].getRopeEndPoint().y + tentacle_move_speed.y))
		else:
			if ropes[0].getRopeEndPoint().y < Globals.initial_end_left_tentacle_position.y:
				ropes[0].setRopeEndPoint(Vector2(ropes[0].getRopeEndPoint().x, ropes[0].getRopeEndPoint().y + tentacle_correction_move_speed.y))
			if ropes[0].getRopeEndPoint().y > Globals.initial_end_left_tentacle_position.y:
				ropes[0].setRopeEndPoint(Vector2(ropes[0].getRopeEndPoint().x, ropes[0].getRopeEndPoint().y - tentacle_correction_move_speed.y))

		if Input.is_action_pressed("leftTentacleGoRight") and \
		(ropes[0].getRopeEndPoint().x + tentacle_move_speed.x <= Globals.tentacle_width_cap) and \
		ropes[0].shipMastAttachedTo == null:
			ropes[0].setRopeEndPoint(Vector2(ropes[0].getRopeEndPoint().x + tentacle_move_speed.x, ropes[0].getRopeEndPoint().y ))
		else:
			if ropes[0].getRopeEndPoint().x > Globals.initial_end_left_tentacle_position.x:
				ropes[0].setRopeEndPoint(Vector2(ropes[0].getRopeEndPoint().x + tentacle_correction_move_speed.x, ropes[0].getRopeEndPoint().y))
			if ropes[0].getRopeEndPoint().x < Globals.initial_end_left_tentacle_position.x:
				ropes[0].setRopeEndPoint(Vector2(ropes[0].getRopeEndPoint().x - tentacle_correction_move_speed.x, ropes[0].getRopeEndPoint().y))

		#Control Right Tentacle:
		if Input.is_action_pressed("rightTentacleGoUp") and \
		(ropes[1].getRopeEndPoint().y + tentacle_move_speed.y >= Globals.tentacle_height_cap) and \
		ropes[1].shipMastAttachedTo == null:
			ropes[1].setRopeEndPoint(Vector2(ropes[1].getRopeEndPoint().x + (tentacle_move_speed.x * 2), ropes[1].getRopeEndPoint().y + tentacle_move_speed.y))
		else:
			if ropes[1].getRopeEndPoint().y < Globals.initial_end_right_tentacle_position.y:
				ropes[1].setRopeEndPoint(Vector2(ropes[1].getRopeEndPoint().x, ropes[1].getRopeEndPoint().y + tentacle_correction_move_speed.y))
			if ropes[1].getRopeEndPoint().y > Globals.initial_end_right_tentacle_position.y:
				ropes[1].setRopeEndPoint(Vector2(ropes[1].getRopeEndPoint().x, ropes[1].getRopeEndPoint().y - tentacle_correction_move_speed.y))
		if Input.is_action_pressed("rightTentacleGoLeft") and \
		(ropes[1].getRopeEndPoint().x - tentacle_move_speed.x >= 0) and \
		ropes[1].shipMastAttachedTo == null:
			ropes[1].setRopeEndPoint(Vector2(ropes[1].getRopeEndPoint().x - tentacle_move_speed.x, ropes[1].getRopeEndPoint().y ))
		else:
			if ropes[1].getRopeEndPoint().x < Globals.initial_end_right_tentacle_position.x:
				ropes[1].setRopeEndPoint(Vector2(ropes[1].getRopeEndPoint().x - tentacle_correction_move_speed.x, ropes[1].getRopeEndPoint().y))
			if ropes[1].getRopeEndPoint().x > Globals.initial_end_right_tentacle_position.x:
				ropes[1].setRopeEndPoint(Vector2(ropes[1].getRopeEndPoint().x + tentacle_correction_move_speed.x, ropes[1].getRopeEndPoint().y))

	if len(ships) < Globals.max_number_of_ships_on_screen:
		spawn_ship(Vector2(Globals.projectResolution.x,180))

