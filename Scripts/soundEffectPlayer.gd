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
	if !drunken or numLoops >= 3:
		queue_free()
	else:
		numLoops += 1
