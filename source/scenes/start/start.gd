extends Control

# Private variables

onready var __button_play: Button = $button_play
onready var __button_settings: Button = $button_settings

onready var __timer: Timer = Timer.new()


# Lifecycle methods

func _ready() -> void:
	__timer.one_shot = false
	add_child(__timer)

	__button_play.connect("pressed", self, "__change_scene", ["main"])
	__button_settings.connect("pressed", self, "__change_scene", ["settings"])

	Transition.fade_in()


# Private methods

func __change_scene(name: String) -> void:
	yield(Transition.fade_out(), "completed")

	__timer.start(0.2)
	yield(__timer, "timeout")

	SceneManager.load_scene(name)
