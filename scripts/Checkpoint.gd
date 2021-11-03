extends Node2D

onready var global_variables = get_tree().get_root().get_node("/root/GlobalVariables")

func _on_Area2D_body_entered(body):
	if body is Player_Class:
		global_variables.curr_section_starting_pos = global_position
		global_variables.curr_section_path = get_tree().current_scene.filename
		global_variables.save_game()
		$AnimationPlayer.stop(false)
		$Light2D.color = Color.yellow
		$Tween.interpolate_property(
			$Sprite2, "position", 
			$Sprite2.position, 
			Vector2(0, 4.733),
			0.5,
			Tween.TRANS_SINE,
			Tween.EASE_IN_OUT
		)
		$Tween.start()
