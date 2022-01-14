extends Node


enum Level { DEBUG = 0, INFO, WARN, ERROR }

var __log_level: int = Level.DEBUG


# Public methods
func set_log_level(level: int) -> void:
	self.__log_level = level


func debug(message: String) -> void:
	if self.__log_level <= Level.DEBUG:
		self.__log("[DBG] %s" % message)


func info(message: String) -> void:
	if self.__log_level <= Level.INFO:
		self.__log("[INF] %s" % message)


func warn(message: String) -> void:
	if self.__log_level <= Level.WARN:
		self.__log("[WRN] %s" % message)


func error(message: String) -> void:
	if self.__log_level <= Level.ERROR:
		self.__log("[ERR] %s" % message)


# Private methods
func __log(message: String) -> void:
	print(message)
