extends Node

var laser_sound = preload("res://assets/sounds/sfx_laser2.ogg")
var die_sound = preload("res://assets/sounds/impactMetal_003.ogg")
var meteor_sound = preload("res://assets/sounds/impactPlank_medium_000.ogg")
var lost_sound = preload("res://assets/sounds/jingles_HIT15.ogg")
var start_sound = preload("res://assets/sounds/jingles_HIT10.ogg")


func play_sound(sound: String):
	var stream = null
	if sound == "laser":
		stream = laser_sound
	elif sound == "die":
		stream = die_sound
	elif sound == "boom":
		stream = meteor_sound
	elif sound == "lost":
		stream = lost_sound
	elif sound == "start":
		stream = start_sound
	else:
		return

	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.stream = stream

	add_child(audio_stream_player)
	audio_stream_player.play()

	await audio_stream_player.finished
	audio_stream_player.queue_free()

