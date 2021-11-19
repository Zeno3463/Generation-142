extends Control

func _ready():
	for child in $VBoxContainer.get_children():
			if child is Button and not child.disabled:
				child.connect("mouse_entered", self, "_on_button_hover")

func _process(_delta):
	$AudioStreamPlayer.volume_db = GlobalVariables.sound_volume
	
	if Input.is_action_just_pressed("pause"):
		visible = not visible
		get_tree().paused = visible
	if Input.is_action_pressed("ui_cancel") and visible:
		visible = false
		get_tree().paused = false

func _on_Resume_button_down():
	visible = false
	get_tree().paused = false

func _on_To_Menu_button_down():
	visible = false
	Ui.load_fade_in_animation()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/Menu.tscn") # warning-ignore:return_value_discarded
	Ui.get_node("Lives").visible = false
	Ui.load_fade_out_animation()
	get_tree().paused = false

func _on_Quit_button_down():
	get_tree().quit()

func _on_button_hover():
	$AudioStreamPlayer.stream = preload("res://sound effects/Hover Button.wav")
	$AudioStreamPlayer.play()
