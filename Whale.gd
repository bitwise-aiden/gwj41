extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = false
var teasing = false
var swimming = false
var tease_movement_speed = Vector2(0.5,0)
var swimming_speeed = Vector2(1,0)
var initPosition = null
# Called when the node enters the scene tree for the first time.
func _ready():
	if initPosition == null:
		initPosition = global_position
	#$OffscreenTimer.start()
	Globals.whaleEnemy = self
	$OffscreenTimer.stop()
	$TeaseTimer.stop()
	active = false
	teasing = false
	swimming = false
	global_position = initPosition
	
func set_active(value):
	active = value
	$OffscreenTimer.start()
	
func _physics_process(delta):
	if teasing:
		tease()
	if swimming:
		if (self.global_position.x > (0 - ($AnimatedSprite.get_sprite_frames().get_frame("peek",0).get_size().x))/2):
			self.global_position.x -= swimming_speeed.x
		else:
			print("Whale has reached the Left edge of the screen")
			_ready()

func tease():
	if self.global_position.x < Globals.projectResolution.x: 
		self.global_position.x += tease_movement_speed.x
	elif self.global_position.x > Globals.projectResolution.x:
		self.global_position.x -= tease_movement_speed.x
	
	if self.global_position.x == Globals.projectResolution.x:
		if teasing:
			$TeaseTimer.start()
			teasing = false

func _on_OffscreenTimer_timeout():
	if active:
		teasing = true

func _on_TeaseTimer_timeout():
	# If we have been on the edge of the screen for long enough, start swimming into the screen
	if active:
		if not swimming:
			swimming = true


func _on_Area2D_body_entered(body):
	print(body, " touched the whale")
