extends CPUParticles2D

func _ready() -> void:
	$free_timer.wait_time = lifetime
	z_index = 69

func _enter_tree() -> void:
	emitting = true
	$free_timer.start()

func _on_free_timer_timeout() -> void:
	self.queue_free()
