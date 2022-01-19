extends AudioStreamPlayer

var audio_path : String

var audio : AudioStream

func _enter_tree() -> void:
	audio = load(audio_path)
	stream = audio
	playing = true


func _on_soundEffectPlayer_finished() -> void:
	queue_free()
