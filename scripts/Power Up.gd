extends Node2D

export(String) var title = ""
export(String, MULTILINE) var description = ""
export(String, "can_double_jump", "can_dash", "can_attack", "can_power_blast") var power_up = ""
export(Array, NodePath) var doors_to_open = []

onready var power_up_explainer = get_tree().get_root().get_node("/root/Ui/Power Up Explainer")
onready var power_up_animation_Player = power_up_explainer.get_node("AnimationPlayer")

func _ready():
	power_up_explainer.get_node("AudioStreamPlayer").volume_db = GlobalVariables.sound_volume

func _on_Area2D_body_entered(body):
	# if Player touches the power up
	if body == Player:
		# enable the Player to perform the desired ability
		GlobalVariables.set(power_up, true)
		
		# open up all the doors
		for door in doors_to_open:
			get_node(door).open()
			
		# display the power up explainer
		power_up_explainer.visible = true
		power_up_explainer.get_node("Title").text = title
		power_up_explainer.get_node("Description").text = description
		power_up_animation_Player.play("Fade In")
		
		# play sound
		power_up_explainer.get_node("AudioStreamPlayer").play()
		
		# pause the game
		get_tree().paused = true
		
		queue_free()
