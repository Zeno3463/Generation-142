extends CanvasLayer

# settings variables
onready var menu_start_pos = $Menu.rect_global_position
onready var settings_start_pos = $Settings.rect_global_position

func _ready():
	get_tree().paused = true
	GlobalVariables.load_settings()
	
	# if the player had played the game before, activate the "continue" button
	var file = File.new()
	if not file.file_exists("user://save.dat"):
		$"Menu/VBoxContainer/Continue".disabled = true
	
	# hide the lives
	Ui.get_node("Lives").visible = false
	
	# connect the signals
	for child in $Menu/VBoxContainer.get_children():
		if child is Button and not child.disabled:
			child.connect("mouse_entered", self, "_on_button_hover")
	$Settings/VBoxContainer/Back.connect("mouse_entered", self, "_on_button_hover") # warning-ignore:return_value_discarded

func _process(_delta):
	# adjust the volume of the buttons
	$AudioStreamPlayer.volume_db = GlobalVariables.sound_volume

func _on_Continue_button_down():
	play_click_sound()
	Ui.load_fade_in_animation()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/Levels/Blue Forest/Blue Forest Section 0.tscn") # warning-ignore:return_value_discarded
	Ui.get_node("Lives").visible = true
	GlobalVariables.load_game()
	Ui.load_fade_out_animation()
	get_tree().paused = false

func _on_New_Game_button_down():
	play_click_sound()
	GlobalVariables.clear_stored_data()
	Ui.load_fade_in_animation()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/Levels/Blue Forest/Blue Forest Section 0.tscn") # warning-ignore:return_value_discarded
	Ui.get_node("Lives").visible = true
	Ui.display_current_level("Section 1: Green Forest")
	GlobalVariables.load_game()
	Ui.load_fade_out_animation()
	get_tree().paused = false

func _on_Quit_button_down():
	get_tree().quit()
	
func _on_button_hover():
	$AudioStreamPlayer.stream = preload("res://sound effects/Hover Button.wav")
	$AudioStreamPlayer.play()
	
func play_click_sound():
	$AudioStreamPlayer.stream = preload("res://sound effects/Press Button.wav")
	$AudioStreamPlayer.play()

func _on_Settings_button_down():
	$Tween.interpolate_property($Settings, "rect_global_position", $Settings.rect_global_position, menu_start_pos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Menu, "rect_global_position", $Menu.rect_global_position, settings_start_pos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Back_button_down():
	$Tween.interpolate_property($Settings, "rect_global_position", $Settings.rect_global_position, settings_start_pos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Menu, "rect_global_position", $Menu.rect_global_position, menu_start_pos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
