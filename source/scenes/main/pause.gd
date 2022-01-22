extends Node2D

# Private variables

onready var __button_pause: Button = $pause_button
onready var __button_restart: Button = $pause_menu/button_restart
onready var __button_menu: Button = $pause_menu/button_menu
onready var __pause_menu: Control = $pause_menu


# Lifecycle methods

func _ready() -> void:
	__button_pause.connect("pressed", self, "__pressed")
	__button_menu.connect("pressed", self, "__change_scene", ["start"])
	__button_restart.connect("pressed", self, "__change_scene", ["main"])


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		__pressed()

# Private methods

func __pressed() -> void:
	__pause_menu.visible = !__pause_menu.visible

	get_tree().paused = __pause_menu.visible

func __change_scene(name: String) -> void:
	yield(Transition.fade_out(), "completed")

	SceneManager.load_scene(name)
