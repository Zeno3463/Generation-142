extends Area2D

export(String) var next_section_path
export(String) var next_level_name
export(bool) var is_boss_fight
onready var ui = get_tree().get_root().get_node("/root/Ui")

# when Player enters the teleporter, teleport
# the Player to the selected section of the level
func _on_Next_Level_Teleporter_body_entered(body):
	if body == Player:
		if is_boss_fight:
			# check if the Player had already fought the boss
			if GlobalVariables.Player_has_entered_scene[next_section_path]:
				return
		
		GlobalVariables.curr_section_path = next_section_path
		if next_level_name != "":
			GlobalVariables.curr_section_name = next_level_name
		
		if not next_section_path in GlobalVariables.visited_section:
			GlobalVariables.visited_section.append(next_section_path)
		
		GlobalVariables.save_game()
		
		get_tree().change_scene(next_section_path) # warning-ignore:return_value_discarded
		if not ui.is_displaying_level: ui.display_current_level(next_level_name)
