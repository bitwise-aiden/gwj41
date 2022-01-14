extends Node


var __queues: Dictionary = {}


# Lifecycle methods
func _init():
	self.pause_mode = PAUSE_MODE_PROCESS


func _process(delta: float) -> void:
	var queues_to_erase: Array = []

	for queue in self.__queues:
		self.__queues[queue].update(delta)

		if self.__queues[queue].is_empty():
			queues_to_erase.append(queue)

	for queue in queues_to_erase:
		self.__queues.erase(queue)


# Public methods
func add_queue(queue: String, task: BaseTask) -> void:
	if !queue in self.__queues:
		self.__queues[queue] = TaskQueue.new()

	self.__queues[queue].add_task(task)


func add_queue_multiple(queue: String, tasks: Array) -> void:
	if !queue in self.__queues:
		self.__queues[queue] = TaskQueue.new()

	self.__queues[queue].add_tasks(tasks)


func clear_queue(queue: String) -> void:
	if queue in self.__queues:
		self.__queues[queue].clear()


func get_queues() -> Array:
	return self.__queues.keys()


func pause_queue(queue: String) -> void:
	if queue in self.__queues:
		self.__queues[queue].pause()


func start_queue(queue: String) -> void:
	if queue in self.__queues:
		self.__queues[queue].start()
