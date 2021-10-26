extends Area2D

export(String) var next_section_path
export(String) var next_level_name
export(bool) var is_boss_fight
onready var player = get_tree().get_root().get_node("/root/Player")
onready var ui = get_tree().get_root().get_node("/root/Ui")
onready var boss_fight_tracker = get_tree().get_root().get_node("/root/BossFightTracker")

# when player enters the teleporter, teleport
# the player to the selected section of the level
func _on_Next_Level_Teleporter_body_entered(body):
	if body == player:
		if is_boss_fight:
			# check if the player had already fought the boss
			if boss_fight_tracker.player_has_entered_scene[next_section_path]:
				return
			else:
				boss_fight_tracker.player_has_entered_scene[next_section_path] = true
		get_tree().change_scene(next_section_path) # warning-ignore:return_value_discarded
		if not ui.is_displaying_level: ui.display_current_level(next_level_name)
