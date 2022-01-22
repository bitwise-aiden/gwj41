class_name Text extends Path2D

# Private variables

var __point_count: int = 0

# Lifecycle methods

func _ready() -> void:
	add_to_group("tentacle")


# Public methods

func points() -> PoolVector2Array:
	return PoolVector2Array(Array(curve.get_baked_points()).slice(0, __point_count))

func show() -> void:
	var tween: Tween = Tween.new()
	add_child(tween)

	tween.interpolate_property(
		self,
		"__point_count",
		0,
		curve.get_baked_points().size(),
		1.5
	)
	tween.start()

	yield(tween, "tween_completed")
	remove_child(tween)
