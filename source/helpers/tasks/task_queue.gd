class_name TaskQueue


var __queue: Array = []
var __running: bool = true


func add_task(task: BaseTask) -> void:
	self.__queue.append(task)


func add_tasks(tasks: Array) -> void:
	for task in tasks:
		self.add_task(task)


func is_empty() -> bool:
	return self.__queue.size() == 0


func clear() -> void:
	self.__queue.clear()


func current() -> BaseTask:
	if self.__queue.size() > 0:
		return self.__queue.front()

	return null


func pause() -> void:
	self.__running = false


func start() -> void:
	self.__running = true


func update(delta: float) -> void:
	if !self.__running || self.is_empty():
		return

	var task = self.__queue.front()

	task.update(delta)

	if task.is_completed():
		self.__queue.pop_front()

