extends Node2D
export var whaleZone = false
var whaleInHugZone = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.set_hug_zone(self)
	$Timer.wait_time = Globals.hugScoreDecayTickDelay
	start_hug_decay_timer()
	Globals.hugScoreTextField.text = str(Globals.hugScore)
	#Globals.set_hug_zone(self)

func start_hug_decay_timer():
	$Timer.start()

func stop_hug_decay_timer():
	$Timer.stop()
	
func _on_Area2D_area_entered(area):
	if whaleZone:
		print("whaleHugZone: ", area)
		if area.get_parent().is_in_group("whale"):
			#area.get_parent().get_hugged()
			#if Globals.whaleHugText.percent_visible < 1:
			Globals.whaleHugText.percent_visible = 1
			if not Globals.whaleEnemy.inHugZone:
				Globals.whaleEnemy.inHugZone = true
	else:
		if area.get_parent().is_in_group("ships"):
			area.get_parent().get_hugged()
			$LoveParticles.emitting = true
			$LoveParticles.amount = area.get_parent().hugHearts
			Globals.hugScore += area.get_parent().hugMeterAmount
			#print("Current Hug Score: ", Globals.hugScore)
		

func _on_Area2D_area_exited(area):
	if whaleZone:
		if area.get_parent().is_in_group("whale"):
			Globals.whaleHugText.percent_visible = 0
			Globals.whaleEnemy.inHugZone = false

func _on_Timer_timeout():
	Globals.hugScore -= Globals.hugScoreDecayTickAmount
	#print("Hug score decay! New Hug Score: ", Globals.hugScore)
	


