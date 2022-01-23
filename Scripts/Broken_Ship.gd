extends Node

var gravity = Vector2(0, 100)  # gravity force
var velocity = Vector2()  # the area's velocity
var active = true
onready var leftHalf = $LeftHalfBody
onready var rightHalf = $RightHalfBody


func _on_StaticCollisionTimer_timeout():
	$LeftHalfBody.mode = RigidBody2D.MODE_STATIC
	$RightHalfBody.mode =  RigidBody2D.MODE_STATIC
