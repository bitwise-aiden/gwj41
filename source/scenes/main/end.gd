extends Node2D

# Private variables

onready var __button_restart: Button = $end_menu/button_restart
onready var __button_menu: Button = $end_menu/button_menu
onready var __end_menu: Control = $end_menu
onready var __high_score: Label = $end_menu/high_score
onready var __new: Label = $end_menu/new


# Lifecycle methods

func _ready() -> void:
	__button_menu.connect("pressed", self, "__change_scene", ["start"])
	__button_restart.connect("pressed", self, "__change_scene", ["main"])

	Event.connect("game_over", self, "__pressed")


# Private methods

func __pressed() -> void:
	__end_menu.visible = !__end_menu.visible

	get_tree().paused = __end_menu.visible

	var previous_highscore: int = SettingsManager.get_setting('highscore', 0)
	if Globals.shipHuggedCount > previous_highscore:
		SettingsManager.set_setting('highscore', Globals.shipHuggedCount, true)
		__new.visible = true

	__high_score.text = "Score: %d" % Globals.shipHuggedCount

	Event.emit_signal("emit_audio", {"type":"music", "name":"end_game"})


func __change_scene(name: String) -> void:

	yield(Transition.fade_out(), "completed")

	SceneManager.load_scene(name)
	get_tree().paused = false
