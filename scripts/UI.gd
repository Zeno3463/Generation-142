extends CanvasLayer

export var lives = 5
export var heart_sprite_size = 40
export var margin_btw_heart_sprites = 10
export var num_of_hits_to_get_extra_life = 2

export var display_dialogue_speed_btw_char = 0.05
export var display_dialogue_speed_btw_sentence = 0.5
export var display_dialogue_speed_btw_sections = 1

export var level_display_popup_delay = 2

# private variables
var num_of_hits = 0
var is_displaying_dialogue = false
var is_displaying_level = false

# node references
onready var player = get_tree().get_root().get_node("/root/Player")

# sprite references
var heart_sprite = preload("res://sprites/UIs/Heart.png")
var empty_heart_sprite = preload("res://sprites/UIs/Empty Heart.png")
var half_empty_heart_sprite = preload("res://sprites/UIs/Half Empty Heart.png")
var filable_heart_sprite = preload("res://sprites/UIs/Fillable Heart.png")

# system functions
func _ready():
	if OS.get_name() == "Windows": OS.window_fullscreen = true
	reset_lives()
	
func _process(_delta):
	# if the player presses F11, exit full screen mode
	if Input.is_action_just_pressed("F11"): OS.window_fullscreen = not OS.window_fullscreen
	
	# if the player kills enough enemies, add a new life to the player
	if num_of_hits >= num_of_hits_to_get_extra_life:
		# if the player does not have max life, add a new life to the player
		if $Lives.get_child_count() <= lives:
			num_of_hits = 0
			add_one_life()
	
	# change the sprite of fillable heart according to the kill count
	match num_of_hits:
		0: $"Lives/Half Heart Sprite".texture = empty_heart_sprite
		1: $"Lives/Half Heart Sprite".texture = half_empty_heart_sprite
		2: $"Lives/Half Heart Sprite".texture = filable_heart_sprite
		
	# hide the power up explainer when escape is pressed
	if Input.is_action_just_pressed("ui_cancel"):
		$"Power Up Explainer".visible = false
		get_tree().paused = false
		
# public functions
func add_one_life():
	var heart_texture = TextureRect.new()
	heart_texture.texture = heart_sprite
	heart_texture.expand = true
	heart_texture.rect_size = Vector2.ONE * 40
	heart_texture.rect_position.x = $Lives.get_child_count() * (heart_sprite_size + margin_btw_heart_sprites)
	$Lives.add_child(heart_texture)
		
func take_out_one_life():
	# if the player ran out of lives, restart the scene
	if $Lives.get_child_count() <= 1:
		
		# get the player respawn pos of the scene
		var player_starting_pos = get_tree().get_root().get_node("/root/Level Node/Player Starting Pos")
		
		player.is_dead = true
		
		# play player dead animation and wait for it to finish before executing the next line
		player.get_node("AnimatedSprite").play("dead")
		yield(player.get_node("AnimatedSprite"), "animation_finished")
		
		# stop the player animation on the last frame
		player.get_node("AnimatedSprite").stop()
		player.get_node("AnimatedSprite").frame = player.get_node("AnimatedSprite").get_sprite_frames().get_frame_count("dead")
		
		# play the fade in animation and wait for it to finish before executing the next line
		load_fade_in_animation()
		yield($"Scene Transtion/AnimationPlayer", "animation_finished")
		
		# reset the lives
		reset_lives()
		
		# reload the scene
		get_tree().reload_current_scene() # warning-ignore:return_value_discarded
		
		# reset the player position to the spawn position
		if is_instance_valid(player) and is_instance_valid(player_starting_pos): player.global_position = player_starting_pos.global_position
	else:
		var child = $Lives.get_child($Lives.get_child_count()-1)
		$Lives.remove_child(child)
		child.queue_free()

func reset_lives():
	player.is_dead = false
	
	load_fade_out_animation()
	
	# delete all the lifes
	for i in $Lives.get_children():
		if i.name != "Half Heart Sprite":
			$Lives.remove_child(i)
			i.queue_free()
	
	# add new lifes
	for i in len(range(lives)):
		add_one_life()
		
func display_the_dialogue(content):
	is_displaying_dialogue = true
	for sentence in content:
		for character in sentence:
			$Dialogue/Label.text += character
			if character == ".": yield(get_tree().create_timer(display_dialogue_speed_btw_sentence), "timeout")
			else: yield(get_tree().create_timer(display_dialogue_speed_btw_char), "timeout")
		yield(get_tree().create_timer(display_dialogue_speed_btw_sections), "timeout")
		$Dialogue/Label.text = ""
	is_displaying_dialogue = false
	
func display_current_level(current_level):
	is_displaying_level = true
	$"Level Displayer/AnimationPlayer".stop()
	$"Level Displayer/Label".text = current_level
	$"Level Displayer/AnimationPlayer".play("Fade In")
	yield($"Level Displayer/AnimationPlayer", "animation_finished")
	yield(get_tree().create_timer(level_display_popup_delay), "timeout")
	$"Level Displayer/AnimationPlayer".play_backwards("Fade In")
	is_displaying_level = false
	
func load_fade_in_animation():
	$"Scene Transtion/AnimationPlayer".play("Fade In")

func load_fade_out_animation():
	$"Scene Transtion/AnimationPlayer".play_backwards("Fade In")
