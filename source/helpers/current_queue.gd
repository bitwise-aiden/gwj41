class_name CurrentQueue


var __default = null
var __queue: Array = []


# Lifecycle methods
func _init(default = null) -> void:
	self.__default = default


# Public methods
func add(value) -> bool:
	if value in self.__queue:
		return false

	self.__queue.append(value)
	return true


func current():
	if self.__queue.size() > 0:
		return self.__queue.front()

	return self.__default


func remove(value) -> bool:
	var index: int = self.__queue.find(value)
	if index == -1:
		return false

	self.__queue.remove(index)
	return true
