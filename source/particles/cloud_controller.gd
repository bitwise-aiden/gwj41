class_name CloudController extends ParticleController


# Public variables

export(Array, Texture) var textures: Array = []


# Lifecycle methods

func _init().(5.0, 2) -> void:
	pass


# Protected methods

func _time_out() -> void:
	texture = textures[randi() % textures.size()]

	restart()
