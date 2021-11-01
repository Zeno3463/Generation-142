extends CanvasLayer

onready var ui = get_tree().get_root().get_node("/root/Ui")
onready var global_variables = get_tree().get_root().get_node("/root/GlobalVariables")

func _ready():
	ui.get_node("Lives").visible = false
	var file = File.new()
	if not file.file_exists("user://save.dat"):
		$"Texts and Buttons/Continue".disabled = true

func _on_Continue_button_down():
	ui.load_fade_in_animation()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/Levels/Blue Forest/Blue Forest Section 0.tscn") # warning-ignore:return_value_discarded
	ui.get_node("Lives").visible = true
	global_variables.load_game()
	ui.load_fade_out_animation()

func _on_New_Game_button_down():
	global_variables.clear_stored_data()
	ui.load_fade_in_animation()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/Levels/Blue Forest/Blue Forest Section 0.tscn") # warning-ignore:return_value_discarded
	ui.get_node("Lives").visible = true
	ui.display_current_level("Section 1: Green Forest")
	ui.load_fade_out_animation()
