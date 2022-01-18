extends Area2D

# Helper variables
var collision_polygon : CollisionPolygon2D
var top_left_point : Vector2
var top_right_point : Vector2

# Resolution variables
export(int) var num_points : int = 8
var point_dict : Dictionary = {}
export(int, 0, 20) var wave_iterations : int = 2
export(float, 0, 1) var wave_spread : float = 0.05


# Physics variables
export(float, 0, 1.0, 0.005) var hookes : float = 0.025
export(float, 0, 10.0, 0.1) var mass : float = 1.0
export(float, 0, 1, 0.01) var dampening : float = 0.05
onready var k_on_m : float = hookes / mass

export(int, 0, 720) var target_height : int = 220

func _ready() -> void:
	collision_polygon = $CollisionPolygon2D
	$Polygon2D.self_modulate.a = 1.0

	# Get our bounds, only along the top edge because water be like that
	top_left_point = collision_polygon.polygon[0]
	top_right_point = collision_polygon.polygon[1]

	# Create the points along the surface
	__create_surface_points()

func _process(delta: float) -> void:
	__update_horizontals()
	__update_verticals()

func __create_surface_points() -> void:
	var new_polygon : PoolVector2Array = PoolVector2Array()
	# Create a dictionary of points, actually modify collision shape to reflect points
	for i in range(num_points + 1):
		# Rounding on the x here to avoid triangulation errors
		var xpos = round((top_right_point.x - top_left_point.x) / num_points * i)
		var ypos = top_left_point.y
		var temp_dict : Dictionary
		# Overwrite collision polygon points
		new_polygon.push_back(Vector2(xpos, ypos))
		temp_dict["position"] = Vector2(xpos, ypos)
		temp_dict["velocity"] = Vector2(0, 0)

		point_dict[str(i)] = temp_dict

	__complete_polygon(new_polygon)

func __update_verticals() -> void:
	var new_polygon : PoolVector2Array = PoolVector2Array()
	for i in range(num_points + 1):
		var pos = point_dict[str(i)]["position"]

		# Do Hooke's Law
		var y = pos.y - target_height
		var acceleration = - k_on_m * y - dampening * point_dict[str(i)]["velocity"].y

		var new_position = pos + point_dict[str(i)]["velocity"]

		# Rounding on the y here to avoid triangulation errors
		new_polygon.push_back(Vector2(new_position.x, round(new_position.y)))
		point_dict[str(i)]["position"] = new_position
		point_dict[str(i)]["velocity"].y += acceleration

	__complete_polygon(new_polygon)

func __update_horizontals() -> void:
	# So what this does is it propogates a change in height along all the springs.
	var left_deltas = []
	left_deltas.resize(num_points + 1)
	var right_deltas = []
	right_deltas.resize(num_points + 1)

	# Iterative process, so run an arbitrary number of times until a nice convergence
	for j in wave_iterations:
		# Pre-calculate height differences
		for i in range(num_points + 1):
			if i > 0:
				left_deltas[i] = wave_spread * (point_dict[str(i)]["position"].y - point_dict[str(i - 1)]["position"].y )
				point_dict[str(i - 1)]["velocity"].y += left_deltas[i]
			if i <= num_points - 1:
				right_deltas[i] = wave_spread * (point_dict[str(i)]["position"].y - point_dict[str(i + 1)]["position"].y )
				point_dict[str(i + 1)]["velocity"].y += right_deltas[i]

		# Apply height differences
		for i in range(num_points + 1):
			if i > 0:
				point_dict[str(i - 1)]["position"].y += left_deltas[i]
			if i <= num_points - 1:
				point_dict[str(i + 1)]["position"].y += right_deltas[i]

func splash(pixel_x_location : int, velocity_change : float) -> void:
	var index = round(pixel_x_location * num_points / (top_right_point.x - top_left_point.x))
	if index > 0 and index < num_points + 1:
		 point_dict[str(index)]["velocity"] += velocity_change

func __complete_polygon(new_polygon) -> void:
	# Add last two points to the polygon, to close the loop.
	new_polygon.push_back(Vector2(1280, 720))
	new_polygon.push_back(Vector2(0, 720))

	# Set the old polygon to the new polygon
	if not Geometry.triangulate_polygon(new_polygon).empty():
		collision_polygon.set_polygon(new_polygon)

		# This bullshit is to set the UV's on the polygon so the shader works properly
		var v0 = new_polygon
		var x0 = INF
		var y0 = INF
		var x1 = -INF
		var y1 = -INF
		for v in v0:
			x0 = min(x0, v.x)
			x1 = max(x1, v.x)
			y0 = min(y0, v.y)
			y1 = max(y1, v.y)
		var s = max(x1 - x0, y1 - y0)
		var d = Vector2(s / 2, s / 2);
		var uv = PoolVector2Array([])
		for v in v0:
			uv.append((v + d) / s)
		$Polygon2D.set_polygon(v0)
		$Polygon2D.set_uv(PoolVector2Array(uv))
