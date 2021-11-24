extends Control

var open_map_sound = preload("res://sound effects/Open Map.wav")

func _process(_delta):
	$AudioStreamPlayer.volume_db = GlobalVariables.sound_volume
	if Input.is_action_just_pressed("open map"):
		visible = not visible
		$AudioStreamPlayer.stream = open_map_sound
		$AudioStreamPlayer.play()
	for children in $Sections.get_children():
		children.visible = false
	for section in GlobalVariables.visited_section:
		$Sections.get_node(section_path_to_name(section)).visible = true
		$Sections.get_node(section_path_to_name(section)).modulate = Color8(0, 0, 0)
	$Sections.get_node(section_path_to_name(GlobalVariables.curr_section_path)).modulate = Color(1.5, 1.5, 1.5)

func section_path_to_name(section_path):
	var section_name = section_path.replace("res://scenes/Levels/", "").replace(".tscn", "")
	while section_name[0] != "/":
		section_name.erase(0, 1)
	section_name.erase(0, 1)
	return section_name
