
# Private variables

onready var __pause_menu: Control = $pause_menu


# Lifecycle methods

func _ready() -> void:
	connect("pressed", self, "__pressed")


# Private methods

func __pressed() -> void:
	__pause_menu.visible = !__pause_menu.visible
