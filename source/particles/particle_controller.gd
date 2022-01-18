class_name ParticleController extends CPUParticles2D


# Private variables

var __check_seconds: float = 2.0
var __check_ratio: int = 10

var __time_elapsed: float = 0.0


 # Lifecycle methods

func _init(seconds: float, ratio: int) -> void:
	__check_seconds = seconds
	__check_ratio = ratio


func _process(delta: float) -> void:
	if emitting:
		return

	__time_elapsed += delta

	if __time_elapsed > __check_seconds:
		__time_elapsed -= __check_seconds

		if randi() % __check_ratio == 0.0:
			_time_out()


# Protected methods

func _time_out() -> void:
	pass
