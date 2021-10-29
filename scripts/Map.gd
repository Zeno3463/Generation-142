extends Control

onready var global_variables = get_tree().get_root().get_node("/root/GlobalVariables")

func _process(_delta):
	if Input.is_action_just_pressed("open map"):
		visible = not visible
	for children in $Sections.get_children():
		children.visible = false
	for section in global_variables.visited_section:
		$Sections.get_node(section_path_to_name(section)).visible = true
		$Sections.get_node(section_path_to_name(section)).modulate = Color8(0, 0, 0)
	$Sections.get_node(section_path_to_name(global_variables.curr_section_path)).modulate = Color(1.5, 1.5, 1.5)

func section_path_to_name(section_path):
	var section_name = section_path.replace("res://scenes/Levels/", "").replace(".tscn", "")
	while section_name[0] != "/":
		section_name.erase(0, 1)
	section_name.erase(0, 1)
	return section_name
