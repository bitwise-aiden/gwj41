extends Sprite


# Public variables

export(Texture) var happy: Texture
export(Texture) var unamused: Texture
export(Texture) var sad: Texture
export(Texture) var concentrate: Texture
export(Texture) var dead: Texture


# Private variables

var __hugging: bool = false
var __default: Texture = happy


# Lifecylce methods

func _ready() -> void:
	Event.connect("hug_update", self, "__hug_update")
	Event.connect("hugging_update", self, "__hugging_update")


# Private methods

func __hug_update(amount: float, max_amount: float) -> void:
	var ratio: float = amount / max_amount

	if ratio > 0.61:
		__default = happy
	elif ratio > 0.2:
		__default = unamused
	else:
		__default = sad

	if !__hugging:
		texture = __default

	if ratio == 0.0:
		texture = dead


func __hugging_update(value: bool) -> void:
	__hugging = value

	if __hugging:
		texture = concentrate
	else:
		texture = __default

