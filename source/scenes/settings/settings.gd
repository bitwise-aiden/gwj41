extends Control

# Private variables

onready var __button_back: Button = $button_back

onready var __timer: Timer = Timer.new()


# Lifecycle methods

func _ready() -> void:
	__timer.one_shot = false
	add_child(__timer)

	__button_back.grab_focus()
	__button_back.connect("pressed", self, "__change_scene", ["start"])

	Transition.fade_in()


# Private methods

func __change_scene(name: String) -> void:
	yield(Transition.fade_out(), "completed")

	__timer.start(0.2)
	yield(__timer, "timeout")

	SceneManager.load_scene(name)
