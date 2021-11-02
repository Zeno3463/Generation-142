extends Node2D

onready var ui = get_tree().get_root().get_node("/root/Ui")

var player_has_entered_scene = {
	"res://scenes/Levels/Blue Forest/Blue Forest Section 3.tscn": false,
	"res://scenes/Levels/Abandoned Village/Abandoned Village Section 3.tscn": false,
	"res://scenes/Levels/Garden Of Poison/Garden Of Poison Section 3.tscn": false,
	"res://scenes/Levels/Under Cave/Under Cave Section 2.tscn": false
}

# can perform abilities
var can_double_jump = false
var can_dash = false
var can_attack = false
var can_power_blast = false

# map
var curr_section_path = "res://scenes/Levels/Blue Forest/Blue Forest Section 0.tscn"
var curr_section_starting_pos = Vector2.ZERO
var curr_section_name = "Section 1: Green Forest"
var visited_section = ["res://scenes/Levels/Blue Forest/Blue Forest Section 0.tscn"]

func clear_stored_data():
	var dir = Directory.new()
	dir.remove("user://save.dat")

func save_game():
	
	# store all global variables in a dictionary
	var data = {
		"player_has_entered_scene": player_has_entered_scene,
		"can_double_jump": can_double_jump,
		"can_dash": can_dash,
		"can_attack": can_attack,
		"can_power_blast": can_power_blast,
		"curr_section_path": curr_section_path,
		"curr_section_name": curr_section_name,
		"visited_section": visited_section,
	}
	
	# store the dictionary into a new file
	var file = File.new()
	var error = file.open("user://save.dat", File.WRITE)
	if error == OK:
		file.store_var(data)
		file.close()
		
func load_game():
	# get the dictionary from the saved file
	var file = File.new()
	if file.file_exists("user://save.dat"):
		var error = file.open("user://save.dat", File.READ)
		
		# map all the global variables to its saved value
		if error == OK:
			var data = file.get_var()
			player_has_entered_scene = data["player_has_entered_scene"]
			can_double_jump = data["can_double_jump"]
			can_dash = data["can_dash"]
			can_attack = data["can_attack"]
			can_power_blast = data["can_power_blast"]
			curr_section_path = data["curr_section_path"]
			curr_section_name = data["curr_section_name"]
			visited_section = data["visited_section"]
			file.close()
			
			# display the current level name to the screen
			ui.display_current_level(curr_section_name)
			
			# change scene to the level
			get_tree().change_scene(curr_section_path) # warning-ignore:return_value_discarded
			
			# wait for 0.01 second
			yield(get_tree().create_timer(0.01), "timeout")
			
			# teleport the player to the level starting pos
			get_parent().get_node("/root/Player/Camera2D").smoothing_enabled = false
			get_parent().get_node("/root/Player").global_position = get_parent().get_node("/root/Level Node/Player Starting Pos").global_position
			
			# snap the camera to the player
			get_parent().get_node("/root/Player/Camera2D").position = Vector2.ZERO
			yield(get_tree().create_timer(0.1), "timeout")
			get_parent().get_node("/root/Player/Camera2D").smoothing_enabled = true
