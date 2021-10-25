extends Area2D

onready var player = get_tree().get_root().get_node("/root/Player")
onready var ui_controller = get_tree().get_root().get_node("/root/Ui")
var time_before_active = 1

func _process(delta):
	time_before_active -= delta
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body == player and time_before_active <= 0:
			ui_controller.take_out_one_life()
			if player.is_dead:
				queue_free()
