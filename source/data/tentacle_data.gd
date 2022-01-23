class_name TentacleData

# Private variables

var __packed_data: PoolColorArray
var __metadata: Color
var __dirty: bool


# Lifecycle methods

func _init(
	dirty: bool = true,
	points: PoolVector2Array = [],
	width_start: float = 15.0,
	width_end: float = 15.0,
	separation: int = 1,
	offset: Vector2 = Vector2.ZERO
) -> void:
	__packed_data = PoolColorArray()

	for point in points:
		var data: Color = Color(
				(offset.x + point.x) / 1280.0,
				(offset.y + point.y) / 720.0,
				0.0,
				0.0
			)

		__packed_data.append(data)

	__metadata = Color(
		__packed_data.size() / 1000.0,
		width_start / 1000.0,
		width_end / 1000.0,
		separation / 1000.0
	)

	__dirty = dirty


# Public methods

func is_dirty() -> bool:
	return __dirty


func metadata() -> Color:
	return __metadata


func packed_data() -> PoolColorArray:
	return __packed_data


func size() -> int:
	return __packed_data.size()
