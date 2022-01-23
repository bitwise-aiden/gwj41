extends Node

var gravity = Vector2(0, 100)  # gravity force
var velocity = Vector2()  # the area's velocity
var active = true
onready var leftHalf = $LeftHalfBody
onready var rightHalf = $RightHalfBody


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	
	#velocity += gravity * delta
	#$LeftHalfBody.sleeping = true
	pass

func _on_StaticCollisionTimer_timeout():
	$LeftHalfBody.mode = RigidBody2D.MODE_STATIC
	$RightHalfBody.mode =  RigidBody2D.MODE_STATIC
