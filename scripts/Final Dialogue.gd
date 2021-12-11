extends Control

export(Array, String, MULTILINE) var person_a
export(Array, String, MULTILINE) var person_b
export var display_dialogue_speed_btw_char = 0.06
export var display_dialogue_speed_btw_sentence = 0.5
export var display_dialogue_speed_btw_sections = 1

var elapsed_time = 0
var start_the_dialogue = false
var is_person_a_turn = true
var is_displaying_dialogue = false

func _ready():
	Music.stop()
	$AudioStreamPlayer.volume_db = GlobalVariables.sound_volume

func _process(delta):
	
	# when the alarm has ended
	if start_the_dialogue:
		get_tree().paused = true
		
		# blacken the screen
		$TextureRect.visible = true
		
		# wait for some time
		yield(get_tree().create_timer(display_dialogue_speed_btw_sections), "timeout")
		
		# start the conversation
		if not is_displaying_dialogue:

			# spawn a new audio Player
			var audio_Player = AudioStreamPlayer.new()
			add_child(audio_Player)
			audio_Player.stream = preload("res://sound effects/Final Level Conversation.wav")

			# let person A and person B talk alternatively
			var content = ""
			var label = null
			if is_person_a_turn:
				if len(person_a) <= 0: return
				content = person_a[0]
				label = $LabelA
				person_a.remove(0)
			else:
				if len(person_b) <= 0: return
				content = person_b[0]
				label = $LabelB
				person_b.remove(0)
			is_person_a_turn = not is_person_a_turn
			
			# display the dialogue
			is_displaying_dialogue = true
			for character in content:
				label.text += character
				if character == ".": yield(get_tree().create_timer(display_dialogue_speed_btw_sentence), "timeout")
				
				# if the dialogue has reached an end, start the credit scene
				elif character == "-":
					
					# hide all the dialogues
					$LabelA.queue_free()
					$LabelB.queue_free()
					
					# play restart simulation sound effect
					var restart_simulation_audio_Player = AudioStreamPlayer.new()
					add_child(restart_simulation_audio_Player)
					restart_simulation_audio_Player.stream = preload("res://sound effects/Restart Simulation.wav")
					restart_simulation_audio_Player.play()
					yield(restart_simulation_audio_Player, "finished")
					
					get_parent().get_node("Credit Scene").play()
					queue_free()
					return
				else: yield(get_tree().create_timer(display_dialogue_speed_btw_char), "timeout")
				if not audio_Player.playing: audio_Player.play()
			yield(get_tree().create_timer(display_dialogue_speed_btw_sections), "timeout")
			audio_Player.queue_free()
			label.text = ""
			is_displaying_dialogue = false
		
	else:
		# if the alarm has not ended yet, flash the red light
		if elapsed_time >= 0.5:
			elapsed_time = 0
			get_parent().get_parent().get_node("Light").visible = not get_parent().get_parent().get_node("Light").visible
		else:
			elapsed_time += delta

func _on_AudioStreamPlayer_finished():
	# start the dialogue
	start_the_dialogue = true
	
	# play restart simulation sound effect
	var restart_simulation_audio_Player = AudioStreamPlayer.new()
	add_child(restart_simulation_audio_Player)
	restart_simulation_audio_Player.stream = preload("res://sound effects/Restart Simulation.wav")
	restart_simulation_audio_Player.play()
