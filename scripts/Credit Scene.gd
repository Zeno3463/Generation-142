extends Control

export(Array, String, MULTILINE) var credits
export var text_duration = 2
export var time_btw_texts = 1

func play():
	$TextureRect2.visible = true
	for i in credits:
		$RichTextLabel.bbcode_text = i
		$AnimationPlayer.play("Fade In")
		yield($AnimationPlayer, "animation_finished")
		yield(get_tree().create_timer(text_duration), "timeout")
		$AnimationPlayer.play_backwards("Fade In")
		yield($AnimationPlayer, "animation_finished")
		yield(get_tree().create_timer(time_btw_texts), "timeout")
