extends AudioStreamPlayer

var audio_path : String

var audio : AudioStream

var drunken : bool = false
var numLoops : int = 0

func _enter_tree() -> void:
	audio = load(audio_path)
	stream = audio
	playing = true


func _on_soundEffectPlayer_finished() -> void:
		queue_free()


func _on_musicPlayer_finished() -> void:
	if !drunken or numLoops >= 3:
		AudioManager.active_music_players.remove(0)
		queue_free()
	else:
		numLoops += 1
		playing = true
