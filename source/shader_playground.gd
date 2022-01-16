extends ColorRect

# Private variables

var __image: Image = Image.new()
var __texture: ImageTexture = ImageTexture.new()

var __vertices: Array = [Vector2(640.0, 360.0), Vector2.ZERO]


# Lifecycle methods

func _ready() -> void:
	set_points(__vertices)


func _process(delta: float) -> void:
	var position: Vector2 = get_viewport().get_mouse_position()

	if !Input.is_mouse_button_pressed(BUTTON_LEFT):
		__vertices.pop_back()

	__vertices.append(position)

	set_points(__vertices)


# Public methods

func set_points(vertices: Array) -> void:
	var size: int = vertices.size()

	__image.create(size, 1, false, Image.FORMAT_RGBAH)
	__image.lock()

	for i in size:
		var vertex: Vector2 = vertices[i]

		var packed_data: Color = Color(
			vertex.x,
			vertex.y,
			0.0,
			0.0
		)

		__image.set_pixel(i, 0, packed_data)

	__image.unlock()

	__texture.create_from_image(__image)

	material.set_shader_param("vertices", __texture)
	material.set_shader_param("vertex_count", size)

