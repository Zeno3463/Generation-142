extends StaticBody2D

func _ready():
	$AudioStreamPlayer.volume_db = GlobalVariables.sound_volume
	$AudioStreamPlayer.play()
	close()

func close():
	$AnimatedSprite.play("default")

func open():
	queue_free()

# stay on the last frame after the closing animation is played
func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	$AnimatedSprite.frame = $AnimatedSprite.frames.get_frame_count("default") - 1
	$CollisionShape2D.disabled = false
