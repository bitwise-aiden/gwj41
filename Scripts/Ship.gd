extends Node2D
export var shipSpawnXPositionOffset = 200
var min_wait_time = 1
var max_wait_time = 10
var active = false
var movement_speed = 3
var min_movement_speed = 0.1
var max_movement_speed = 3
var movement_speed_modifier = Globals.ship_speed_modifier
var rng = RandomNumberGenerator.new()
var tentaclesAttached = []
# have to figure out a better way to do this:
var leftSailEnabled = true
var rightSailEnabled = true
var hugMeterAmount = 20
var hugHearts = 5
var hugZone
var hugSpeed = Globals.hugSpeed

func _ready():
	rng.randomize()
	$OffScreenTimer.wait_time = rng.randf_range(min_wait_time, max_wait_time)
	$OffScreenTimer.start()
	rng.randomize()
	movement_speed = (rng.randf_range(min_movement_speed, max_movement_speed) * movement_speed_modifier)
	hugZone = Globals.get_hug_zone()
	
	reset_collision()

func reset_collision():
	$LeftSail.set_deferred("monitoring", true)
	$LeftSail.set_deferred("monitorable", true)
	$RightSail.set_deferred("monitoring", true)
	$RightSail.set_deferred("monitorable", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if len(tentaclesAttached) > 1:
			#print("Start pulling ship into hugzone")
			# If we are to the left of hugzone, go right
			if (global_position.x < hugZone.global_position.x):
				global_position.x += hugSpeed.x
			elif (global_position.x > hugZone.global_position.x):
				global_position.x -= hugSpeed.x
			if (global_position.y <= hugZone.global_position.y):
				global_position.y += hugSpeed.y
			if (global_position.y > hugZone.global_position.y):
				global_position.y -= hugSpeed.y
			# If we are to the right of hugzone, go left
			# If we are above hugzone, go down
			
			#global_position.y += movement_speed
		else:
			global_position.x -= movement_speed
	if active and global_position.x < (0 - ($AnimatedSprite.get_sprite_frames().get_frame("sail",0).get_size().x)*$AnimatedSprite.scale.x):
		destroy_object()
			
func destroy_object():
	if is_instance_valid(self):
		for tentacle in tentaclesAttached:
			tentacle.detatch_from_ship_mast(tentacle.get_mast_attached())
		for child in self.get_children():
			child.queue_free()
		queue_free()

func get_hugged():
	destroy_object()

func _on_OffScreenTimer_timeout():
	active = true
	$AnimatedSprite.play()
	hugZone = Globals.get_hug_zone()

func _on_RightSail_body_entered(body):
	if body.is_in_group("ropeEndPiece") and (!(body.get_parent() in tentaclesAttached)):
		body.get_parent().attach_to_ship_mast($RightSail)
		tentaclesAttached.append(body.get_parent())
		rightSailEnabled = false
		reset_collision()
		

func _on_LeftSail_body_entered(body):
	if body.is_in_group("ropeEndPiece") and (!(body.get_parent() in tentaclesAttached)):
		body.get_parent().attach_to_ship_mast($LeftSail)
		tentaclesAttached.append(body.get_parent())
		leftSailEnabled = false
		reset_collision()
