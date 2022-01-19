extends Button


# Public variables

var points: PoolVector2Array = PoolVector2Array()


# Private variables

var __lower: bool = false
var __timer: Timer = Timer.new()


# Lifecycle methods

func _ready() -> void:
	add_child(__timer)

	__timer.start(randf() * 0.3)
	yield(__timer, "timeout")

	__timer.connect("timeout", self, "__toggle_text")
	__timer.start(0.3)


# Private methods

func __toggle_text() -> void:
	if __lower:
		text = text.to_upper()
	else:
		text = text.to_lower()

	__lower = !__lower
