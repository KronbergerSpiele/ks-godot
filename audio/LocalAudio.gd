extends Node
class_name LocalAudio

func play(stream: AudioStream, _uniquifier: String = ""):
	if stream == null:
		return

	var player = AudioStreamPlayer2D.new()
	player.stream = stream
	player.bus = "Actors"
	# If we are a child of a 2D node, this player will follow it if added as child.
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)
