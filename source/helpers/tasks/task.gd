class_name Task

class CameraShake:
	extends BaseTask


	var __camera: Camera2D
	var __duration: float
	var __intensity: float


	func _init(camera: Camera2D, intensity: float, duration: float) -> void:
		self.__camera = camera
		self.__duration = duration
		self.__intensity = intensity


	func update(delta: float) -> void:
		self.__duration = max(0.0, self.__duration - delta)

		self.__camera.set_offset(
			Vector2(
				randf() * self.__intensity,
				randf() * self.__intensity
			)
		)

		if self.__duration <= 0.0:
			self.__camera.set_offset(Vector2.ZERO)
			self._completed = true


class Lerp:
	extends BaseTask


	var __callback: FuncRef
	var __duration: float
	var __elapsed: float
	var __variant_start
	var __variant_end


	func _init(start, end, duration: float ,
		callback: FuncRef) -> void:
			self.__callback = callback
			self.__duration = duration
			self.__elapsed = 0.0
			self.__variant_start = start
			self.__variant_end = end


	func update(delta: float) -> void:
		self.__elapsed = min(self.__duration, self.__elapsed + delta)

		var variant_delta = lerp(self.__variant_start, self.__variant_end,
			self.__elapsed / self.__duration)
		self.__callback.call_func(variant_delta)

		if self.__elapsed >= self.__duration:
			self._completed = true


class RunFunc:
	extends BaseTask


	var __arguments: Array
	var __function: FuncRef


	func _init(function: FuncRef, arguments: Array = []):
		self.__arguments = arguments
		self.__function = function


	func update(delta: float) -> void:
		self.__function.call_funcv(self.__arguments)
		self._completed = true


class Wait:
	extends BaseTask


	var __duration: float


	func _init(duration: float):
		self.__duration = duration


	func update(delta: float) -> void:
		self.__duration = max(0.0, self.__duration - delta)

		if self.__duration <= 0.0:
			self._completed = true


class WaitForFunc:
	extends BaseTask


	var __arguments: Array
	var __function: FuncRef


	func _init(function: FuncRef, arguments: Array = []):
		self.__arguments = arguments
		self.__function = function


	func update(delta: float) -> void:
		self._completed = self.__function.call_funcv(self.__arguments)


class WaitForTask:
	extends BaseTask


	var __task: BaseTask


	func _init(task: BaseTask):
		self.__task = task


	func update(delta: float) -> void:
		self._completed = self.__task.is_completed()
