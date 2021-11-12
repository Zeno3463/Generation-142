extends CanvasLayer

onready var ui = get_tree().get_root().get_node("/root/Ui")

func _ready():
	var file = File.new()
	if not file.file_exists("user://save.dat"):
		$"Menu/VBoxContainer/Continue".disabled = true
		
	ui.get_node("Lives").visible = false
	
	for child in $Menu/VBoxContainer.get_children():
		if child is Button and not child.disabled:
			child.connect("mouse_entered", self, "_on_button_hover")
		

func _on_Continue_button_down():
	play_click_sound()
	ui.load_fade_in_animation()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/Levels/Blue Forest/Blue Forest Section 0.tscn") # warning-ignore:return_value_discarded
	ui.get_node("Lives").visible = true
	GlobalVariables.load_game()
	ui.load_fade_out_animation()

func _on_New_Game_button_down():
	play_click_sound()
	GlobalVariables.clear_stored_data()
	ui.load_fade_in_animation()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/Levels/Blue Forest/Blue Forest Section 0.tscn") # warning-ignore:return_value_discarded
	ui.get_node("Lives").visible = true
	ui.display_current_level("Section 1: Green Forest")
	ui.load_fade_out_animation()

func _on_Quit_button_down():
	get_tree().quit()
	
func _on_button_hover():
	$AudioStreamPlayer.stream = preload("res://sound effects/Hover Button.wav")
	$AudioStreamPlayer.play()
	
func play_click_sound():
	$AudioStreamPlayer.stream = preload("res://sound effects/Press Button.wav")
	$AudioStreamPlayer.play()
