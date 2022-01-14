extends TextureButton


export (String) var scene_name


# Lifecycle methods
func _ready() -> void:
	self.connect("button_up", SceneManager, "load_scene", [self.scene_name])
