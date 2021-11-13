extends StaticBody2D

class_name Crate_Class

var amplitude = 200
var time = 0.05

onready var camera = get_tree().get_root().get_node("/root/Player/Camera2D")

func explode():
	var audio_Player = AudioStreamPlayer.new()
	add_child(audio_Player)
	audio_Player.stream = preload("res://sound effects/Enemy Hurt.wav")
	audio_Player.volume_db = GlobalVariables.sound_volume
	audio_Player.play()
	camera.shake(amplitude, time)
	$AnimatedSprite.play("explode")
	yield($AnimatedSprite, "animation_finished")
	queue_free()
