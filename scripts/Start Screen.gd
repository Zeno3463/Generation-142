extends Control

export var disclaimer_sign_duration = 5

func _ready():
	if OS.get_name() == "HTML5":
		$AnimationPlayer.play("Fade In")
		yield($AnimationPlayer, "animation_finished")
		yield(get_tree().create_timer(disclaimer_sign_duration), "timeout")
		$AnimationPlayer.play_backwards("Fade In")
