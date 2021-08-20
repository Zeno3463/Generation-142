# teleports the player to the selected section of the game

extends Area2D

export(String) var next_section_path
onready var player = get_tree().get_root().get_node("/root/Player")

func _on_Next_Level_Teleporter_body_entered(body):
	if body == player:
		get_tree().change_scene(next_section_path)