extends Control

func _ready():
	GlobalVariables.load_settings()
	$"VBoxContainer/Music Slider".value = GlobalVariables.music_volume
	$"VBoxContainer/Sound Slider".value = GlobalVariables.sound_volume

func _on_Sound_Slider_value_changed(value):
	GlobalVariables.sound_volume = value
	GlobalVariables.save_settings()

func _on_Music_Slider_value_changed(value):
	GlobalVariables.music_volume = value
	GlobalVariables.save_settings()
