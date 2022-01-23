extends TextureRect

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

# Water splash
var splash = preload("res://Parts/splashes.tscn")


export(float, 0.0, 720.0) var target_height : float = 220.0

func _ready() -> void:
	Event.connect("water_splash", self, "splash")
	Globals.water_height = target_height
	Transition.fade_in()
	
	# Get our bounds, only along the top edge because water be like that
	top_left_point = Vector2(0, target_height)
	top_right_point = Vector2(1280, target_height)
	

	# Create the points along the surface
	__create_surface_points()

func _physics_process(delta: float) -> void:
	__update_horizontals()
	__update_verticals()
	__pass_to_shader(point_dict)

func __create_surface_points() -> void:
	# Create a dictionary of points, actually modify collision shape to reflect points
	for i in range(num_points + 1):
		# Rounding on the x here to avoid triangulation errors
		var xpos = round((top_right_point.x - top_left_point.x) / num_points * i)
		var ypos = target_height
		var temp_dict : Dictionary
		
		# Overwrite collision polygon points
		temp_dict["position"] = Vector2(xpos, ypos)
		temp_dict["velocity"] = Vector2(0, 0)
		point_dict[str(i)] = temp_dict
	


func __update_verticals() -> void:
	for i in range(num_points + 1):
		var pos = point_dict[str(i)]["position"]

		# Do Hooke's Law
		var y = pos.y - target_height
		var acceleration = - k_on_m * y - dampening * point_dict[str(i)]["velocity"].y

		var new_position = pos + point_dict[str(i)]["velocity"]

		# Rounding on the y here to avoid triangulation errors
		point_dict[str(i)]["position"] = new_position
		point_dict[str(i)]["velocity"].y += acceleration
	


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


func splash(pixel_x_location : int, velocity_change : float, origin : String) -> void:
	var index = floor(pixel_x_location / (num_points + 1) * 2)
	if index > 0 and index <= num_points + 1 and point_dict[str(index)]["velocity"].y <= velocity_change/2:
		point_dict[str(index)]["velocity"].y = velocity_change
	if origin != "ship":
		var splashes = splash.instance()
		match origin:
			"tentacle":
				splashes.lifetime = 1.5
				splashes.amount = 16
				splashes.initial_velocity = 40
			"ship_hugged":
				splashes.lifetime = 2.0
				splashes.amount = 32
				splashes.initial_velocity = 60
		splashes.position = Vector2(pixel_x_location, point_dict[str(index)]["position"].y)
		self.call_deferred("add_child", splashes)


func __pass_to_shader(points : Dictionary) -> void:
	var position_array : PoolVector2Array = PoolVector2Array()
	var y_max = 0
	for i in range(points.size()):
		position_array.push_back(points[str(i)]["position"])
		if y_max < position_array[i].y:
			y_max = position_array[i].y
	
	var width = 1280
	var height = 1
	var position_image = Image.new()
	position_image.create(width, height, false, Image.FORMAT_RGBAF)
	
	# Put position data into image. For luls, x(r)->x, y(g)->y
	position_image.lock()
	var pre_a = Vector2(-1000, target_height)
	var post_b = Vector2(2280, target_height)
	var j = -1
	var steps : int = floor((width-1) / num_points)
	
	# I would comment this right now, but FML I need to get to work
	for i in range(width):
		var ypos2
		if i % steps == 0 :
			j = j + 1
		if j >= num_points:
			j = num_points
			ypos2 = position_array[-1]
		else:
			ypos2 = position_array[j+1]
		
		var ypos = position_array[j]
		var value = float(i % steps) / float(steps - 1)
		var y_cerp = ypos.cubic_interpolate(ypos2, pre_a, post_b, value)
		
		position_image.set_pixel(i, 0, Color(0.0,  y_cerp.y / 720.0 , 0.0, 0.0))
	position_image.unlock()
	
	var position_texture = ImageTexture.new()
	position_texture.create_from_image(position_image)
	material.set_shader_param("y_positions", position_texture)
