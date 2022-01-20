extends Node2D
export var whaleZone = false
var whaleInHugZone = false

# Called when the node enters the scene tree for the first time.
func set_hugScoreTextField(value):
	print("setting hugScoreTextField:", value)

func _enter_tree():
	print("Entered tree in the hug zone")
	Globals.set_hug_zone(self)
	$Timer.wait_time = Globals.hugScoreDecayTickDelay

func start_hug_decay_timer():
	print("Start timer: ", $Timer)
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
			print(self, " reporting Globals.whaleEnemy.inHugZone = ", Globals.whaleEnemy.inHugZone)
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
		print("Something exited the whale zone", area)
		if area.get_parent().is_in_group("whale"):
			Globals.whaleHugText.percent_visible = 0
			Globals.whaleEnemy.inHugZone = false

func _on_Timer_timeout():
	#print("Hug score: ", Globals.hugScore, " Decay tick amount: ", Globals.hugScoreDecayTickAmount)
	Globals.hugScore -= Globals.hugScoreDecayTickAmount
	#print("Hug score decay! New Hug Score: ", Globals.hugScore)
	


