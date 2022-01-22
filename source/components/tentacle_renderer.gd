class_name TentacleRenderer extends ColorRect


# Private variables

var __image: Image = Image.new()
var __texture: ImageTexture = ImageTexture.new()

var __vertices: Array = [Vector2(640.0, 360.0), Vector2.ZERO]


# Lifecycle methods

func _ready() -> void:
	__image.create(400, 10, false, Image.FORMAT_RGBAH)

func _process(delta: float) -> void:
	var tentacles_raw: Array = get_tree().get_nodes_in_group("tentacle")
	var tentacles: Array = []

	for tentacle in tentacles_raw:
		if tentacle is Text:
			tentacles.append(
				TentacleData.new(
					true,
					tentacle.points(),
					20.0,
					20.0,
					3,
					Vector2(90.0, -10.0)
				)
			)
		elif tentacle is Rope:
			if tentacle.dirty:
				tentacles.append(
					TentacleData.new(
						true,
						tentacle.rope_points,
						30.0,
						10.0,
						4
					)
				)

				tentacle.dirty = false
			else:
				tentacles.append(TentacleData.new(false))

	set_points(tentacles)


# Public methods

func set_points(tentacles: Array) -> void:
	var row_count: int = tentacles.size()
	var col_count: int = 0

	var dirty: bool = false

	for tentacle in tentacles:
		col_count = max(col_count, tentacle.size())
		dirty = dirty || tentacle.is_dirty()

	if !dirty:
		return

	__image.lock()

	for r in min(row_count, 400):
		var tentacle: TentacleData = tentacles[r]

		if tentacle.is_dirty():
			__image.set_pixel(0, r, tentacle.metadata())

			var packed_data: PoolColorArray = tentacle.packed_data()
			for c in tentacle.size():
				__image.set_pixel(c + 1, r, packed_data[c])

	__image.unlock()

	__texture.create_from_image(__image)

	material.set_shader_param("tentacles", __texture)
	material.set_shader_param("tentacle_count", row_count)

