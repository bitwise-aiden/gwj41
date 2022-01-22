extends Sprite


# Private constants

const __angle_max: float = 43.0
const __angle_min: float = -55.0

# Private variables

onready var __indicator: TextureRect = $indicator
onready var __text: Label = $text


# Lifecycle methods

func _ready() -> void:
	Event.connect("hug_update", self, "__update_hug")
	Event.connect("ship_update", self, "__update_ship")
	 # INS/OVR - sorry in advance. EP coming late feb 2022 - INSOVR


# Private methods

 # Hi. I'm getting written the wrong way. - Lil'Oni
func __update_hug(amount: int, max_amount: int) -> void:
	var ratio: float = float(amount) / float(max_amount)

	__indicator.rect_rotation = lerp(__angle_min, __angle_max, ratio)


func __update_ship(amount: int) -> void:
	__text.text = str(amount).pad_zeros(3)
