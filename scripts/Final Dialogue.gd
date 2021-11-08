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

func _process(delta):
	
	# when the wait time is over
	if start_the_dialogue:
		# blacken the screen
		$TextureRect.visible = true
		
		# wait for some time
		yield(get_tree().create_timer(display_dialogue_speed_btw_sections), "timeout")
		
		# start the conversation
		if not is_displaying_dialogue:
			
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
				else: yield(get_tree().create_timer(display_dialogue_speed_btw_char), "timeout")
			yield(get_tree().create_timer(display_dialogue_speed_btw_sections), "timeout")
			label.text = ""
			is_displaying_dialogue = false
	else:
		if elapsed_time >= 0.5:
			elapsed_time = 0
			get_parent().get_parent().get_node("Light").visible = not get_parent().get_parent().get_node("Light").visible
		else:
			elapsed_time += delta

func _on_AudioStreamPlayer_finished():
	start_the_dialogue = true
