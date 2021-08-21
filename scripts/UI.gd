extends CanvasLayer

export var lives = 5
export var heart_sprite_size = 40
export var margin_btw_heart_sprites = 10
var heart_sprite = preload("res://sprites/UIs/Heart.png")
onready var player = get_tree().get_root().get_node("/root/Player")

func _ready():
	reset_lives()
		
func take_out_one_life():
	$Lives.remove_child($Lives.get_child($Lives.get_child_count()-1))
	
	# if the player ran out of lives, restart the scene
	if $Lives.get_child_count() <= 0:
		var player_starting_pos = get_tree().get_root().get_node("/root/Level Node/Player Starting Pos")
		player.is_dead = true
		player.get_node("AnimatedSprite").play("dead")
		yield(player.get_node("AnimatedSprite"), "animation_finished")
		player.get_node("AnimatedSprite").stop()
		player.get_node("AnimatedSprite").frame = player.get_node("AnimatedSprite").get_sprite_frames().get_frame_count("dead")
		load_fade_in_animation()
		yield($"Scene Transtion/AnimationPlayer", "animation_finished")
		reset_lives()
		get_tree().change_scene(get_tree().current_scene.get_path())
		player.global_position = player_starting_pos.global_position
		load_fade_out_animation()
		
func reset_lives():
	player.is_dead = false
	load_fade_out_animation()
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
