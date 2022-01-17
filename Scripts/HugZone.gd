extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.set_hug_zone(self)
	#Globals.hugScoreDecayTickRate
	$Timer.wait_time = Globals.hugScoreDecayTickDelay
	$Timer.start()
	Globals.hugScoreTextField.text = str(Globals.hugScore)
	Globals.set_hug_zone(self)
	
func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("ships"):
		area.get_parent().get_hugged()
		$LoveParticles.emitting = true
		$LoveParticles.amount = area.get_parent().hugHearts
		Globals.hugScore += area.get_parent().hugMeterAmount
		#print("Current Hug Score: ", Globals.hugScore)

func _process(delta):
	Globals.hugScoreTextField.text = str(Globals.hugScore)
	if Globals.hugScore <= 0:
		print("YOU LOSE")
		

func _on_Timer_timeout():
	Globals.hugScore -= Globals.hugScoreDecayTickAmount
	#print("Hug score decay! New Hug Score: ", Globals.hugScore)
	
