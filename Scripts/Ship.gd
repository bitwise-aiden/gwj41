extends Node2D
export var shipSpawnXPositionOffset = 200

var min_wait_time = 1
var max_wait_time = 10
var active = false
var movement_speed
var min_movement_speed = 50
var max_movement_speed = 300
var rng = RandomNumberGenerator.new()
var tentaclesAttached = []
# have to figure out a better way to do this:
var leftSailEnabled = true
var rightSailEnabled = true
var hugMeterAmount = 20
var hugHearts = 5
var hugZone
var hugSpeed = Globals.hugSpeed * Globals.ship_speed_modifier
var waterline
var hasSunk = false
var water

onready var __bubbles: CPUParticles2D = $bubbles
var __timer: Timer = Timer.new()

func _enter_tree() -> void:
	waterline = position.y

func _ready():
	rng.randomize()
	$OffScreenTimer.wait_time = rng.randf_range(min_wait_time, max_wait_time)
	$OffScreenTimer.start()
	rng.randomize()
	movement_speed = (rng.randf_range(min_movement_speed, max_movement_speed) * Globals.ship_speed_modifier)
	hugZone = Globals.get_hug_zone()
	water = get_parent().get_node("water")
	reset_collision()
	__timer.one_shot = true
	add_child(__timer)

func reset_collision():
	$LeftSail.set_deferred("monitoring", true)
	$LeftSail.set_deferred("monitorable", true)
	$RightSail.set_deferred("monitoring", true)
	$RightSail.set_deferred("monitorable", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if active:
		# Set the splash!
		Event.emit_signal("water_splash", clamp(position.x, 0, 1280) + 30, (movement_speed) / (100), "ship")
		if len(tentaclesAttached) > 1:
			if (global_position.x < hugZone.global_position.x):
				global_position.x += hugSpeed.x
			elif (global_position.x > hugZone.global_position.x):
				global_position.x -= hugSpeed.x
			if (global_position.y <= hugZone.global_position.y):
				global_position.y += hugSpeed.y
			if (global_position.y > hugZone.global_position.y):
				global_position.y -= hugSpeed.y
		else:
			global_position.x -= movement_speed * delta
	if active and global_position.x < (0 - ($AnimatedSprite.get_sprite_frames().get_frame("sail",0).get_size().x)*$AnimatedSprite.scale.x):
		destroy_object()

	if !hasSunk:
		check_waterline()

func destroy_object():
	if is_instance_valid(self):
		Event.emit_signal("emit_ship_death", self)
		for tentacle in tentaclesAttached:
			tentacle.detatch_from_ship_mast(tentacle.get_mast_attached())
		for child in self.get_children():
			child.queue_free()
		queue_free()

func get_hugged():
	Globals.shipHuggedCount += 1
	#Globals.shipsHuggedCountTextField.text = str(Globals.shipHuggedCount)
	if (Globals.shipHuggedCount > 0 ) and (posmod(Globals.shipHuggedCount, Globals.parrotShipWaitCount) == 0):
		# Emit a spawn parrot signal
		# This shouldn't be done here. The ship should just emit a signal that it was hugged and be done with it.
		Event.emit_signal("spawn_parrot")
	if (Globals.shipHuggedCount > 0 ) and (posmod(Globals.shipHuggedCount, Globals.difficultyScoreCount) == 0):
		Globals.increase_difficulty_level(Globals.difficultyLevel + Globals.difficultyLevelIncrement)
	Event.emit_signal("emit_audio", {"type": "effect", "name": "wood_break"})
	Event.emit_signal("emit_audio", {"type": "effect", "name": "hug"})
	Event.emit_signal("spawn_new_broken_ship", self)
	destroy_object()

func _on_OffScreenTimer_timeout():
	active = true
	hasSunk = false
	$AnimatedSprite.play()
	hugZone = Globals.get_hug_zone()
	Event.emit_signal("water_splash", clamp(position.x, 0, 1280), 5, "ship")
	if randf() < 0.75:
		Event.emit_signal("emit_audio", {"type": "effect", "name": "ship"})


func _on_RightSail_body_entered(body):
	if body.is_in_group("ropeEndPiece") and (!(body.get_parent() in tentaclesAttached) and not body.get_parent().get_mast_attached()):
		body.get_parent().attach_to_ship_mast($RightSail)
		tentaclesAttached.append(body.get_parent())
		rightSailEnabled = false
		reset_collision()
		# After a few seconds, the tentacle will break free by itself.
		$BreakFreeTimer.start()

		if tentaclesAttached.size() > 1:
			Event.emit_signal("hugging_update", true)
			Event.emit_signal("water_splash", clamp(position.x, 0, 1280) + 40, 50, "ship_hug")
			__timer.start(0.1)
			yield(__timer, "timeout")
			__bubbles.restart()


func _on_LeftSail_body_entered(body):
	if body.is_in_group("ropeEndPiece") and (!(body.get_parent() in tentaclesAttached) and not body.get_parent().get_mast_attached()):
		body.get_parent().attach_to_ship_mast($LeftSail)
		tentaclesAttached.append(body.get_parent())
		leftSailEnabled = false
		reset_collision()
		# After a few seconds, the tentacle will break free by itself.
		$BreakFreeTimer.start()

		if tentaclesAttached.size() > 1:
			Event.emit_signal("hugging_update", true)
			Event.emit_signal("water_splash", clamp(position.x, 0, 1280) + 40, 50, "ship_hug")
			__timer.start(0.1)
			yield(__timer, "timeout")
			__bubbles.restart()

func _on_BreakFreeTimer_timeout():
	if len(tentaclesAttached) == 1:
		tentaclesAttached[0].detatch_from_ship_mast(tentaclesAttached[0].get_mast_attached())
		tentaclesAttached = []
		reset_collision()

func check_waterline() -> void:
	if position.y > waterline:
		hasSunk = true
		Event.emit_signal("emit_audio", {"type": "effect", "name": "sunk"})
