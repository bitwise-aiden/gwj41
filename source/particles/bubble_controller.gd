class_name BubbleController extends ParticleController



# Lifecycle methods

func _init().(2.0, 10) -> void:
	pass

# Protected methods

func _time_out() -> void:
	Event.emit_signal("emit_audio", {"type": "effect", "name": "bubbles"})
	restart()
