tool
class_name GodotReset extends EditorPlugin

signal enable_ridiculous_coding()

const MINIMIZED_RESOURCE: Resource = preload("res://addons/godot_reset/minimized.tscn")
var minimized_instance: Control = null

var __regex: Dictionary = {
	"set_color": "^#?([0-9a-f]{3}|[0-9a-f]{6})$",
	"black": "^#?(0{3}|0{6})$"
}
var __server: UDPServer = null
var __settings: EditorSettings = null
var __timer_poll: Timer = null
var __timer_coding: Timer = null
var __timer_invert: Timer = null
var __timer: Timer = null



func _enter_tree() -> void:
	print("Godot Reset enabled")

	self.__settings = self.get_editor_interface().get_editor_settings()

	self.__timer_poll = Timer.new()
	self.__timer_poll.autostart = true
	self.__timer_poll.wait_time = 0.3
	self.__timer_poll.connect("timeout", self, "__poll")
	self.add_child(self.__timer_poll)

	self.__timer_coding = Timer.new()
	self.__timer_coding.wait_time = 60.0
	self.__timer_coding.one_shot = true
	self.__timer_coding.connect("timeout", self, "__disable_coding")
	self.add_child(self.__timer_coding)

	self.__timer_invert = Timer.new()
	self.__timer_invert.wait_time = 30.0
	self.__timer_invert.one_shot = true
	self.__timer_invert.connect("timeout", self, "__disable_invert")
	self.add_child(self.__timer_invert)

	self.__timer = Timer.new()
	self.__timer.one_shot = true
	self.add_child(self.__timer)

	for key in self.__regex.keys():
		var ex = RegEx.new()
		ex.compile(self.__regex[key])
		self.__regex[key] = ex


func _exit_tree() -> void:
	print("Godot Reset disabled")


	if self.minimized_instance != null:
		var editor: EditorInterface  = self.get_editor_interface()
		var base_control: Control = editor.get_base_control()

		base_control.remove_child(self.minimized_instance)
		self.minimized_instance = null


var __focused_text_edit: TextEdit = null


func _process(delta: float) -> void:
	var editor: EditorInterface  = self.get_editor_interface()

	if !OS.window_minimized && self.minimized_instance != null:
		var base_control: Control = editor.get_base_control()
		base_control.remove_child(self.minimized_instance)
		self.minimized_instance = null

	var script_editor: ScriptEditor = editor.get_script_editor()

	for text_edit in self.__find_text_edits(script_editor):
		if text_edit.has_focus():
			self.__focused_text_edit = text_edit
			return


func __find_text_edits(parent: Node) -> Array:
	var text_edits: Array = []

	for child in parent.get_children():
		if child.get_child_count():
			text_edits.append_array(self.__find_text_edits(child))

		if child is TextEdit:
			text_edits.append(child)

	return text_edits


func __disable_coding() -> void:
	var editor: EditorInterface = self.get_editor_interface()
	editor.set_plugin_enabled("ridiculous_coding", false)


func __disable_invert() -> void:
	var editor: EditorInterface = self.get_editor_interface()
	var base_control: Control = editor.get_base_control()

	base_control.rect_scale.x = abs(base_control.rect_scale.x)


func __poll() -> void:
	if self.__server == null:
		self.__server = UDPServer.new()
		self.__server.listen(4242)

	self.__server.poll()
	if self.__server.is_connection_available():
		var peer : PacketPeerUDP = self.__server.take_connection()
		var pkt = peer.get_packet()

		var result = JSON.parse(pkt.get_string_from_utf8())
		if result.error:
			return

		var data = result.result

		match data:
			{"type": "set_color", "color": var color, "username": var username}:
				if !self.__regex["set_color"].search(color.to_lower()):
					print("Sorry %s, %s is an invalid color" % [username, color])
					return # testing - velopman

				if username.to_lower() == "liioni":
					if self.__regex["black"].search(color.to_lower()):
						print("Surprise, surprise! Liioni with the %s" % color)
					else:
						print("WHAT!? Liioni didn't use #000000!?!?")
				else:
					print("Setting editor to %s for %s!" % [color, username])

				self.__settings.set_setting(
					"interface/theme/base_color",
					color
				)
			{"type": "enable_ridiculous_coding", "username": var username}:
				print("Time to get ridiculous thanks to %s!" % username)

				var editor: EditorInterface = get_editor_interface()
				editor.set_plugin_enabled("ridiculous_coding", true)

				self.__timer_coding.start()
			{"type": "add_comment", "username": var username, "comment": var comment}:
				if username == 'Liioni':
					username = 'Lil\'Oni'

				if !self.__focused_text_edit:
					print("Sorry %s, it looks like there are no open scripts")
					return

				print("%s has left a comment in the code" % username)
				# this part of the code was sponsored by RAID SHADOW LEGENDS - Lumikkode

				var cursor_line: int = self.__focused_text_edit.cursor_get_line()
				var cursor_column: int = self.__focused_text_edit.cursor_get_column()
				var scroll_horizontal: int = self.__focused_text_edit.scroll_horizontal
				var scroll_vertical: float = self.__focused_text_edit.scroll_vertical

				var line_length = self.__focused_text_edit.get_line(cursor_line).length()
				self.__focused_text_edit.cursor_set_column(line_length)

				self.__focused_text_edit.insert_text_at_cursor(" # %s - %s" % [comment, username]) # expletive - TheYagich # pee break - totally_not_a_spambot

				self.__focused_text_edit.cursor_set_line(cursor_line)
				self.__focused_text_edit.cursor_set_column(cursor_column)
				self.__focused_text_edit.scroll_horizontal = scroll_horizontal
				self.__focused_text_edit.scroll_vertical = scroll_vertical
			{"type": "minimize_godot", "username": var username}:
				if username == "Lumikkode":
					print("(not) Brought to you by Lumi! <3")
				else:
					print("%s doesn't want you to work!" % username)

				var editor: EditorInterface = get_editor_interface()
				var base_control: Control = editor.get_base_control()
				var instance: Control = MINIMIZED_RESOURCE.instance()

				base_control.add_child(instance)

				yield(self.get_tree(), "idle_frame")

				self.minimized_instance = instance

				# the (last?) comment on the same line - TheYagich
				OS.window_minimized = true
			{"type": "invert_godot", "username": var username}:
				print("%s turned things around!" % username)

				var editor: EditorInterface = get_editor_interface()
				var base_control: Control = editor.get_base_control()

				base_control.rect_pivot_offset.x = base_control.rect_size.x * 0.5
				base_control.rect_scale.x *= -1.0

				self.__timer_invert.start()
			{"type": "randomize_godot", "username": var username}:
				if username == "Lumikkode":
					print("We are going to get random on behalf of Lumi!")
				else:
					print("%s wants us to get random!" % username)

				var editor: EditorInterface = get_editor_interface()
				var base_control: Control = editor.get_base_control()

				base_control.rect_scale *= 0.5
				base_control.rect_pivot_offset.x = 0.0

				var half_size: Vector2 = base_control.rect_size * 0.5

				for i in 10:
					for v in [Vector2.ZERO, Vector2(half_size.x, 0.0), half_size, Vector2(0.0, half_size.y)]:
						base_control.rect_position = v

						self.__timer.start(0.1)
						yield(self.__timer, "timeout")

				base_control.rect_position = Vector2(0.0, 0.0)
				base_control.rect_scale = Vector2.ONE

			_:
				print("invalid payload: ", typeof(data), data)

				# Hello world, this is velop! How are you today?
