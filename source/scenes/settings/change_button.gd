class_name ChangeButton extends BoardButton


# Public variables

export(String) var binding: String


# Private methods

var __current: int = 0
var __listening: bool = false


# Lifecycle methods

func _ready() -> void:
	self.__current = InputManager.get_key(self.binding)
	self.__update_text()

	self.connect("focus_exited", self, "__focus_exited")
	self.connect("pressed", self, "__pressed")


func _input(event: InputEvent) -> void:
	if self.__listening && event is InputEventKey && event.pressed:
		self.__update_text_color(Color.white)

		var incoming: int = event.scancode

		if incoming == self.__current:
			self.get_tree().set_input_as_handled()
			self.__listening = false
			self.__update_text()
			return

		if InputManager.is_used(incoming):
			self.get_tree().set_input_as_handled()
			self.__update_text_color(Color("#b1385c"))
			self.__update_text(incoming)
			return

		InputManager.set_key(self.binding, incoming)

		self.__current = incoming
		self.__listening = false
		self.__update_text()
		self.get_tree().set_input_as_handled()


# Private methods

func __focus_exited() -> void:
	self.__listening = false
	self.__update_text()
	self.__update_text_color(Color.white)


func __pressed() -> void:
	self.__listening = true
	self.text = "..."


func __update_text(override: int = -1) -> void:
	var value: int = self.__current

	if override != -1:
		value = override

	self.text = OS.get_scancode_string(value)

func __update_text_color(color: Color) -> void:
	self.add_color_override("font_color", color)
	self.add_color_override("font_color_focus", color)
	self.add_color_override("font_color_hover", color)
