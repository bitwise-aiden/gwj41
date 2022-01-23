extends Node

var effect_player = preload("res://source/helpers/soundEffectPlayer.tscn")
var music_player = preload("res://source/helpers/musicPlayer.tscn")

var active_music_players : Array = []

var __volume_max: Dictionary = {
	# key: bus name
	# value: starting volume
}
var __volume_min: float = -40.0


# Lifecylce methods
func _ready() -> void:
	randomize()
	var levels = SettingsManager.get_setting("volume", {})
	for key in levels.keys():
		var index = self.__get_bus_index(key)
		self.__volume_max[key] = AudioServer.get_bus_volume_db(index)
		var value: float = lerp(self.__volume_min, self.__volume_max[key], levels[key])
		AudioServer.set_bus_volume_db(index, value)

	var success = Event.connect("emit_audio", self, "play_audio")

# Public methods
func get_volume(name: String) -> float:
	return SettingsManager.get_setting("volume/%s" % name, 1.0)

func get_volume_db(name: String) -> float:
	var volume: float = self.get_volume(name)
	return lerp(self.__volume_min, self.__volume_max[name], volume)


func set_volume(name: String, value: float) -> void:
	var index: int = self.__get_bus_index(name)

	var volume_db: float = -INF
	if value > 0.0:
		volume_db = lerp(self.__volume_min, self.__volume_max[name], value)
	AudioServer.set_bus_volume_db(index, volume_db)

	SettingsManager.set_setting("volume/%s" % name, value, true)


# Private methods
func __get_bus_index(name: String) -> int:
	return AudioServer.get_bus_index(name)


func play_audio(incoming : Dictionary) -> void:
	if incoming["type"] == "effect":
		var new_player = effect_player.instance()
		var effect = incoming["name"]
		new_player.pitch_scale = rand_range(0.85, 1.15)
		match effect:
			"bubbles":
				var rand_sound = randi() % 3
				match rand_sound:
					0:
						new_player.audio_path = "res://assets/audio/sfx/bubble.ogg"
					1:
						new_player.audio_path = "res://assets/audio/sfx/bubble2.ogg"
					2:
						new_player.audio_path = "res://assets/audio/sfx/bubble_old.ogg"

			"ship":
				var rand_sound = randi() % 3
				match rand_sound:
					0:
						new_player.audio_path = "res://assets/audio/sfx/random_chatter.ogg"
					1:
						new_player.audio_path = "res://assets/audio/sfx/ship_bell.ogg"
					2:
						new_player.audio_path = "res://assets/audio/sfx/whistle.ogg"
						new_player.volume_db = -10

			"parrot":
				var rand_sound = randi() % 2
				match rand_sound:
					0:
						new_player.audio_path = "res://assets/audio/sfx/parrot_whistle_1.ogg"
					1:
						new_player.audio_path = "res://assets/audio/sfx/parrot_squarwk_1.ogg"
			
			"parrot_hug":
				var rand_sound = randi() % 6
				match rand_sound:
					0:
						new_player.audio_path = "res://assets/audio/sfx/parrot_squawk_2.ogg"
					1:
						new_player.audio_path = "res://assets/audio/sfx/pun-01.ogg"
					2:
						new_player.audio_path = "res://assets/audio/sfx/pun-02.ogg"
					3:
						new_player.audio_path = "res://assets/audio/sfx/pun-03.ogg"
					4:
						new_player.audio_path = "res://assets/audio/sfx/pun-04.ogg"
					5:
						new_player.audio_path = "res://assets/audio/sfx/pun-05.ogg"
				
				
			"sunk":
				new_player.audio_path = "res://assets/audio/sfx/dragged_under_splash.ogg"

			"wood_break":
				new_player.audio_path = "res://assets/audio/sfx/wood_break.ogg"

			"hug":
				var eat = randf()
				if eat > 0.01:
					new_player.audio_path = "res://assets/audio/sfx/nomnomnom.ogg"
				else:
					var rand_sound = randi() % 2
					match rand_sound:
						0:
							new_player.audio_path = "res://assets/audio/sfx/hug.ogg"
						1:
							new_player.audio_path = "res://assets/audio/sfx/hug2.ogg"

			"transition":
				new_player.audio_path = "res://assets/audio/sfx/bubble_transition.ogg"

		self.add_child(new_player)
	if incoming["type"] == "music":
		var new_player = music_player.instance()
		var music = incoming["name"]
		match music:
			"background":
				var rand_music = randi() % 2
				match rand_music:
					0:
						new_player.drunken = true
						new_player.audio_path = "res://assets/audio/music/drunken_sailor.ogg"
					1:
						new_player.audio_path = "res://assets/audio/music/tale_of_the_kraken.ogg"
			"main_menu":
				new_player.audio_path = "res://assets/audio/music/tale_of_the_kraken.ogg"
			"end_game":
				active_music_players[0].playing = false
				new_player.audio_path = "res://assets/audio/music/tale_of_the_kraken.ogg"
				new_player.endGame = true
				new_player.paused = false
				
		active_music_players.push_back(new_player)
		self.add_child(new_player)
