# This class is to help better control time within the game.
# For best results have this as the first singleton loaded in `auto load`.
# Thanks to https://github/NoelFB for inspiring this idea.
extends Node


# Whether or not the class processes the delta time for _process or
# _physics_process
var _process_physics: bool = false

# Time since the game started
var elapsed_time: float = 0.0

# Time since the game started for the previous frame
var elapsed_time_previous: float = 0.0

# Time since the last frame
var delta_time: float = 0.0


# Lifecycle methods
func _process(delta: float) -> void:
	if !self._process_physics:
		self.__handle_delta(delta)


func _physics_process(delta: float) -> void:
	if self._process_physics:
		self.__handle_delta(delta)


# Public methods
func on_interval(interval: float, offset: float) -> bool:
	return floor((self.elapsed_time_previous - offset) / interval) < \
		floor((self.elapsed_time - offset) / interval)


func on_time(time: float, timestamp: float) -> bool:
	return time >= timestamp && time - self.delta_time < timestamp


func on_timestamp(timestamp: float) -> bool:
	return self.elapsed_time >= timestamp && \
		self.elapsed_time_previous < timestamp


func scale_float(value: float) -> float:
	return value * Globals.time_modifier


func scale_vector2(value: Vector2) -> Vector2:
	return value * Globals.time_modifier


func scale_vector3(value: Vector3) -> Vector3:
	return value * Globals.time_modifier


# Private methods
func __handle_delta(delta: float) -> void:
	self.delta_time = delta * Globals.time_modifier
	self.elapsed_time_previous = self.elapsed_time
	self.elapsed_time += self.delta_time
