extends Node2D

# Private variables

onready var __button_restart: Button = $end_menu/button_restart
onready var __button_menu: Button = $end_menu/button_menu
onready var __end_menu: Control = $end_menu


# Lifecycle methods

func _ready() -> void:
	__button_menu.connect("pressed", self, "__change_scene", ["start"])
	__button_restart.connect("pressed", self, "__change_scene", ["main"])

	Event.connect("game_over", self, "__pressed")


# Private methods

func __pressed() -> void:
	__end_menu.visible = !__end_menu.visible

	get_tree().paused = __end_menu.visible


func __change_scene(name: String) -> void:
	yield(Transition.fade_out(), "completed")

	SceneManager.load_scene(name)
	get_tree().paused = false
