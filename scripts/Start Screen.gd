extends Control

export var brand_duration = 3

func _ready():
	if OS.get_name() == "HTML5":
		$AnimationPlayer.play("Load Disclaimer")
		yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("Load Brand")
	yield(get_tree().create_timer(brand_duration), "timeout")
	$AnimationPlayer.play_backwards("Load Brand")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("Fade Out")
