extends ColorRect

# Private variables

var __image: Image = Image.new()
var __texture: ImageTexture = ImageTexture.new()

var __vertices: Array = [Vector2(640.0, 360.0), Vector2.ZERO]


# Lifecycle methods


func _process(delta: float) -> void:
	var ropes: Array = get_tree().get_nodes_in_group("tentacle")
	var ropes_points: Array = []

	for rope in ropes:
		ropes_points.append(rope.rope_points)

	set_points(ropes_points)


# Public methods

func set_points(vertices_array: Array) -> void:
	var row_count: int = vertices_array.size()
	var col_count: int = 0

	for vertices in vertices_array:
		col_count = max(col_count, vertices.size())

	__image.create(col_count + 1, row_count, false, Image.FORMAT_RGBAH)
	__image.lock()

	for r in row_count:
		var vertices: PoolVector2Array = vertices_array[r]
		var meta_data: Color = Color(
			vertices.size(),
			0.0,
			0.0,
			0.0
		)

		__image.set_pixel(0, r, meta_data)

		for c in vertices.size():
			var vertex: Vector2 = vertices[c]

			var packed_data: Color = Color(
				vertex.x,
				vertex.y,
				0.0,
				0.0
			)

			__image.set_pixel(c + 1, r, packed_data)

	__image.unlock()

	__texture.create_from_image(__image)

	material.set_shader_param("vertices_array", __texture)
	material.set_shader_param("array_count", row_count)

