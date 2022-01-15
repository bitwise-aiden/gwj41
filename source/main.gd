extends ColorRect


# Private constants

const __center_screen: Vector2 = Vector2(640.0, 360.0)


# Lifecycle methods

func _ready() -> void:
	material.set_shader_param("line_start", __center_screen)


func _process(delta: float) -> void:
	var position_current: Vector2 = get_viewport().get_mouse_position()
	material.set_shader_param("line_end", position_current)

