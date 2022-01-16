extends Node2D
export var shipSpawnXPositionOffset = 200
var min_wait_time = 1
var max_wait_time = 10
var active = false
var movement_speed = 3
var rng = RandomNumberGenerator.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$OffScreenTimer.wait_time = rng.randf_range(min_wait_time, max_wait_time)
	$OffScreenTimer.start()
	#var my_random_number = rng.randf_range(-10.0, 10.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		global_position.x -= movement_speed
	if active and global_position.x < 0:
		if is_instance_valid(self):
			for child in self.get_children():
				child.queue_free()
			queue_free()


func _on_OffScreenTimer_timeout():
	active = true
	pass # Replace with function body.
