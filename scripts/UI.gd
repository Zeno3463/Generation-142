extends CanvasLayer

export var lives = 5
export var heart_sprite_size = 40
export var margin_btw_heart_sprites = 10
var heart_sprite = preload("res://sprites/UIs/Heart.png")
onready var player = get_tree().get_root().get_node("/root/Player")

func _ready():
	reset_lives()
		
func take_out_one_life():
	# if the player ran out of lives, restart the scene
	if $Lives.get_child_count() <= 0:
		
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
		get_tree().change_scene(get_tree().current_scene.get_path())
		
		# reset the player position to the spawn position
		player.global_position = player_starting_pos.global_position
	else:
		var child = $Lives.get_child(0)
		$Lives.remove_child(child)
		child.queue_free()

func reset_lives():
	player.is_dead = false
	
	load_fade_out_animation()
	
	for i in $Lives.get_children():
		$Lives.remove_child(i)
		i.queue_free()
	
	for i in len(range(lives)):
		var heart_texture = TextureRect.new()
		heart_texture.texture = heart_sprite
		heart_texture.expand = true
		heart_texture.rect_size = Vector2.ONE * 40
		heart_texture.rect_position.x = i * (heart_sprite_size + margin_btw_heart_sprites)
		$Lives.add_child(heart_texture)
		
func load_fade_in_animation():
	$"Scene Transtion/AnimationPlayer".play("Fade In")

func load_fade_out_animation():
	$"Scene Transtion/AnimationPlayer".play_backwards("Fade In")
