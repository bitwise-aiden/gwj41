extends CPUParticles2D


# Private constants

const __CHECK_SECONDS: float = 2.0
const __CHECK_RATIO: int = 10


# Private variables

var __time_elapsed: float = 0.0


 # Lifecycle methods

func _process(delta: float) -> void:
	if emitting:
		return

	__time_elapsed += delta

	if __time_elapsed > __CHECK_SECONDS:
		__time_elapsed -= __CHECK_SECONDS

		if randi() % __CHECK_RATIO == 0.0:
			restart()
