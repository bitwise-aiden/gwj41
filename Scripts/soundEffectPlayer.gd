extends AudioStreamPlayer

var audio_path : String

var audio : AudioStream

var endGame : bool = false
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
		var size = AudioManager.active_music_players.size()
		if size == 1:
			AudioManager.active_music_players.remove(0)
		else:
			AudioManager.active_music_players.remove(-1)
		if endGame:
			Event.emit_signal("emit_audio", {"type": "music", "name": "end_game"})
		else:
			Event.emit_signal("emit_audio", {"type": "music", "name": "background"})
		queue_free()
	else:
		numLoops += 1
		playing = true
