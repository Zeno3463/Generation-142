extends StaticBody2D

class_name Crate_Class

var amplitude = 200
var frequency = 0.5
var time = 0.05

onready var camera = get_tree().get_root().get_node("/root/Player/Camera2D")

func explode():
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = preload("res://sound effects/Enemy Hurt.wav")
	audio_player.play()
	camera.start(amplitude, frequency, time)
	$AnimatedSprite.play("explode")
	yield($AnimatedSprite, "animation_finished")
	queue_free()
