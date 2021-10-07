extends Area2D

export(String) var next_section_path
export(String) var next_level_name
onready var player = get_tree().get_root().get_node("/root/Player")
onready var ui = get_tree().get_root().get_node("/root/Ui")

# when player enters the teleporter, teleport
# the player to the selected section of the level
func _on_Next_Level_Teleporter_body_entered(body):
	if body == player:
		get_tree().change_scene(next_section_path) # warning-ignore:return_value_discarded
		if not ui.is_displaying_level: ui.display_current_level(next_level_name)
