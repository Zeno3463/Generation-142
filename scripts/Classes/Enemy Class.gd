# all enemies will inherit this class

extends KinematicBody2D

class_name Enemy_Class

# basic movement variables
export var speed = 30
export var jump_force = -150
export var gravity = 5
export var die_animation_speed = 3

# diagonal movement variables
var dir = Vector2.ONE

# screen shake variables
export var amplitude = 200
export var frequency = 0.5
export var time = 0.05

# explosive particle variables
export(Color) var particle_color
var explosive_particle = preload("res://scenes/Objects/Explosive Particles.tscn")

# private variables
var vel = Vector2.ZERO
var is_dead = false
var is_going_left = false
var can_shoot = true
onready var ui_controller = get_tree().get_root().get_node("/root/Ui")
onready var player = get_tree().get_root().get_node("/root/Player")

# node references
var enemy_animated_sprite: AnimatedSprite = null
var enemy_dead_animation_name = ""
var enemy_shoot_animation_name = ""
var enemy_vunerable_area: Area2D = null
onready var camera: Camera2D = player.get_node("Camera2D")

# functions
func move_left():
	enemy_animated_sprite.flip_h = true
	vel.x = -speed
	
func move_right():
	enemy_animated_sprite.flip_h = false
	vel.x = speed
	
func jump():
	vel.y = jump_force
	var audio_player = AudioStreamPlayer.new()
	
func stop_moving():
	vel.x = 0
	
func move_diagonal():
	vel = dir * speed
	
	# flip the enemy sprite to the direction it is facing
	if vel.x < 0: enemy_animated_sprite.flip_h = true
	else: enemy_animated_sprite.flip_h = false
	
	# randomize the direction of movement when it is on wall
	if is_on_ceiling() or is_on_floor() or is_on_wall():
		dir = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	
func follow_object(object):
	var angle = get_angle_to(object.global_position)
	vel = Vector2(cos(angle), sin(angle)) * speed
	if vel.x < 0: enemy_animated_sprite.flip_h = true
	else: enemy_animated_sprite.flip_h = false
	
func jump_onto_object(object_pos, jump_move_speed):
	# follow player
	var dist_to_object = global_position.x - object_pos.x
	vel.x = gravity * dist_to_object / jump_force * jump_move_speed
	
	# flip the animated sprite
	if dist_to_object > 0:
		enemy_animated_sprite.flip_h = true
	else:
		enemy_animated_sprite.flip_h = false
	
func fall():
	if is_on_floor():
		vel.y = 0
	else:
		vel.y += gravity
	
func die(add_num_of_hits=true, spawn_particle=true, play_sound=true):
	is_dead = true
	
	get_node("CollisionShape2D").disabled = true
	
	if add_num_of_hits: 
		# screen shake
		camera.start(amplitude, frequency, time)
		# add one life to player
		ui_controller.num_of_hits += 1
		
	if spawn_particle:
		# spawn particle
		var explosive_particle_instance = explosive_particle.instance()
		get_parent().add_child(explosive_particle_instance)
		explosive_particle_instance.global_position = global_position
		explosive_particle_instance.color = particle_color
		explosive_particle_instance.emitting = true
	
	# load hurt sound
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = preload("res://sound effects/Enemy Hurt.wav")
	if play_sound:
		audio_player.play()
	
	# play animation
	enemy_animated_sprite.play(enemy_dead_animation_name)
	enemy_animated_sprite.speed_scale = die_animation_speed
	yield(enemy_animated_sprite, "animation_finished")
	enemy_animated_sprite.visible = false
	
	if play_sound and audio_player.playing: yield(audio_player, "finished")
	
	queue_free()
	
# system functions
func _on_Edge_Detector_body_exited(body):
	# if is on edge, change the direction
	if body != self and body is TileMap:
		is_going_left = not is_going_left
		
func _physics_process(_delta):
	# if player stomped enemy, damage the enemy
	if enemy_vunerable_area != null:
		if enemy_vunerable_area.overlaps_body(player) and not player.is_hurt and not is_dead:
			enemy_dead_animation_name = "die by stomp"
			player.jump_count = 0
			player.jump(false)
			die()
		
func _on_Deadly_Area_body_entered(body):
	# if player touches enemy, damage the player
	if body == player and not player.is_hurt:
		player.jump_count = 0
		player.jump()
		player.take_damage()
