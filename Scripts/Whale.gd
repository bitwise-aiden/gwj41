extends Node2D

var active = false
var teasing = false
var swimming = false
var beingHugged = false
var inHugZone = false
var brokeFree = false

var tease_movement_speed = Vector2(0.5,0)
var swimming_speeed = Vector2(3,0)
var initPosition = null
var hugPressCount = 0
var maxNumberOfPressesBeforeGettingHugged = 30
onready var tentaclesAttached = []
onready var tentacleAttachPoints = [$AttachmentPoints/LeftAttachpoint1, $AttachmentPoints/LeftAttachpoint2, $AttachmentPoints/LeftAttachpoint3, $AttachmentPoints/RightAttachpoint1, $AttachmentPoints/RightAttachpoint2, $AttachmentPoints/RightAttachpoint3]

# Called when the node enters the scene tree for the first time.
func _ready():
	if initPosition == null:
		initPosition = global_position
	else:
		global_position = initPosition
	$OffscreenTimer.stop()
	$TeaseTimer.stop()
	active = false
	teasing = false
	swimming = false
	beingHugged = false
	inHugZone = false
	brokeFree = false
	tentaclesAttached = []
	hugPressCount = 0
	global_position = initPosition
	
func set_active(value):
	active = value
	$OffscreenTimer.start()
	
func add_to_hug_count(number_of_hugs_to_add):
	hugPressCount += number_of_hugs_to_add
	if hugPressCount >= maxNumberOfPressesBeforeGettingHugged:
		pass
	

func attach_tentacle(tentacle):
	tentaclesAttached.append(tentacle)

func get_hugged():
	set_being_hugged(true)
	$BreakFreeTimer.start()
	Globals.hug_zone.stop_hug_decay_timer()

func get_being_hugged():
	return(beingHugged)

func set_being_hugged(value):
	beingHugged = value

func _physics_process(delta):
	
	if teasing and not beingHugged:
		tease()
	if swimming and not beingHugged:
		if (global_position.x > (0 - ($AnimatedSprite.get_sprite_frames().get_frame("peek",0).get_size().x))/2):
			global_position.x -= swimming_speeed.x
		else:
			#reset_state()
			_ready()

func tease():
	if global_position.x < Globals.projectResolution.x: 
		global_position.x += tease_movement_speed.x
	elif global_position.x > Globals.projectResolution.x:
		global_position.x -= tease_movement_speed.x
	
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
			
func destroy_object():
	if is_instance_valid(self):
		brokeFree = true
		beingHugged = false
		Globals.hug_zone.start_hug_decay_timer()
		
		for child in self.get_children():
			child.queue_free()
		queue_free()

func _on_BreakFreeTimer_timeout():
	if len(tentaclesAttached) > 0:
		var tentacleToRemove = int(len(tentaclesAttached)-1)
		tentaclesAttached[tentacleToRemove].resetToInitialPositions()
		tentaclesAttached.remove(tentacleToRemove)
		$BreakFreeTimer.start()
	else:
		#Keep swimming off screen but avoid being hugged again
		brokeFree = true
		beingHugged = false
		Globals.hug_zone.start_hug_decay_timer()
