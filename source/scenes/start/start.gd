extends Control

# Private variables

onready var __button_exit: Button = $button_exit
onready var __button_play: Button = $button_play
onready var __button_settings: Button = $button_settings
onready var __puns: Label = $puns
onready var __text: Text = $text
onready var __title: Button = $title

onready var __timer: Timer = Timer.new()


# Lifecycle methods

func _ready() -> void:
	randomize()

	__timer.one_shot = false
	add_child(__timer)

	__button_play.connect("pressed", self, "__change_scene", ["main"])
	__button_settings.connect("pressed", self, "__change_scene", ["settings"])
	__button_exit.connect("pressed", self, "__exit")

	if OS.has_feature("JavaScript"):
		remove_child(__button_exit)

	var original_position: Vector2 = __title.rect_position
	__title.rect_position.y -= 500

	yield(Transition.fade_in(), "completed")
	__text.show()

	var tween: Tween = Tween.new()
	add_child(tween)

	tween.interpolate_property(
		__title,
		"rect_position",
		__title.rect_position,
		original_position,
		0.5,
		Tween.TRANS_BOUNCE,
		Tween.EASE_OUT,
		1.0
	)
	tween.start()
	yield(tween, "tween_completed")


	__button_play.grab_focus()

	tween.interpolate_property(
		__puns,
		"modulate",
		Color.transparent,
		Color.white,
		0.5
	)
	tween.start()
	yield(tween, "tween_completed")

	remove_child(tween)




# Private methods

func __change_scene(name: String) -> void:
	yield(Transition.fade_out(), "completed")

	__timer.start(0.2)
	yield(__timer, "timeout")

	SceneManager.load_scene(name)


func __exit() -> void:
	yield(Transition.fade_out(), "completed")

	__timer.start(0.5)
	yield(__timer, "timeout")

	get_tree().quit()
