extends Area2D

onready var ui_controller = get_tree().get_root().get_node("/root/Ui")
var time_before_active = 1

func _process(delta):
	time_before_active -= delta
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body == Player and time_before_active <= 0:
			ui_controller.take_out_one_life()
			if Player.is_dead:
				queue_free()
