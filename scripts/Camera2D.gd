extends Camera2D

onready var player = get_tree().get_root().get_node("/root/Player")
var dont_follow_player = false

func _process(delta):
	# follow the player
	if not dont_follow_player:
		global_position = player.global_position
