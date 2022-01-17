extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.set_hug_zone(self)

func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("ships"):
		area.get_parent().get_hugged()
		
		#print("FOUND A SHIP TO HUG!!")
