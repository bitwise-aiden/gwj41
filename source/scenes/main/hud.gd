extends Sprite


# Private constants

const __angle_max: float = 43.0
const __angle_min: float = -55.0

# Private variables

onready var __addition: CPUParticles2D = $addition
onready var __indicator: TextureRect = $indicator
onready var __text: Label = $text

var __tween: Tween = Tween.new()
var __previous_amount: int = 0

# Lifecycle methods

func _ready() -> void:
	add_child(__tween)

	Event.connect("hug_update", self, "__update_hug")
	Event.connect("ship_update", self, "__update_ship")
	 # INS/OVR - sorry in advance. EP coming late feb 2022 - INSOVR


# Private methods

 # Hi. I'm getting written the wrong way. - Lil'Oni
func __update_hug(amount: float, max_amount: float) -> void:
	var ratio: float = amount / max_amount

	__indicator.rect_rotation = lerp(__angle_min, __angle_max, ratio)

	if amount > __previous_amount:
		__tween.interpolate_property(
			__indicator,
			"modulate",
			Color("#85b567"),
			Color.white,
			0.5
		)
		__tween.start()

	__previous_amount = amount



func __update_ship(amount: int) -> void:
	__text.text = str(amount).pad_zeros(3)
	__addition.restart()
