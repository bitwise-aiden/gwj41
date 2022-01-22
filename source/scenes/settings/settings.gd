extends Control

var Rope = preload("res://Parts/Rope.tscn")

# Private variables

onready var __button_back: Button = $button_back

onready var __timer: Timer = Timer.new()


# Lifecycle methods

func _ready() -> void:
	__timer.one_shot = false
	add_child(__timer)

	__button_back.grab_focus()
	__button_back.connect("pressed", self, "__change_scene", ["start"])

	var left_tentacle = __spawn_tentacle(
		Globals.initial_start_left_tentacle_position,
		Globals.initial_end_left_tentacle_position
	)
	var right_tentacle = __spawn_tentacle(
		Globals.initial_start_right_tentacle_position,
		Globals.initial_end_right_tentacle_position
	)

	Transition.fade_in()


# Private methods

func __change_scene(name: String) -> void:
	yield(Transition.fade_out(), "completed")

	__timer.start(0.2)
	yield(__timer, "timeout")

	SceneManager.load_scene(name)


func __spawn_tentacle(start_pos, end_pos):
		var rope = Rope.instance()
		add_child(rope)
		rope.spawn_rope(start_pos, end_pos)
		return(rope)
