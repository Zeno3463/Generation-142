extends Control

func _process(_delta):
	if Input.is_action_just_pressed("open map"):
		visible = not visible
