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

# node references
var enemy_animated_sprite: AnimatedSprite = null
var enemy_dead_animation_name = ""
var enemy_shoot_animation_name = ""
var enemy_vunerable_area: Area2D = null
onready var camera: Camera2D = Player.get_node("Camera2D")

# functions
func move_left():
	enemy_animated_sprite.flip_h = true
	vel.x = -speed
	
func move_right():
	enemy_animated_sprite.flip_h = false
	vel.x = speed
	
func jump():
	vel.y = jump_force
	
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
	vel = (object.global_position - global_position).normalized() * speed
	if vel.x < 0: enemy_animated_sprite.flip_h = true
	else: enemy_animated_sprite.flip_h = false
	
func jump_onto_object(object_pos, jump_move_speed):
	# follow Player
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
	
	get_node("CollisionShape2D").set_deferred("disabled", true)
	
	if add_num_of_hits: 
		# screen shake
		camera.shake(amplitude, time)
		# add one life to Player
		ui_controller.num_of_hits += 1
		
	if spawn_particle:
		# spawn particle
		var explosive_particle_instance = explosive_particle.instance()
		get_parent().add_child(explosive_particle_instance)
		explosive_particle_instance.global_position = global_position
		explosive_particle_instance.color = particle_color
		explosive_particle_instance.emitting = true
	
	# load hurt sound
	var audio_Player = AudioStreamPlayer.new()
	add_child(audio_Player)
	audio_Player.volume_db = GlobalVariables.sound_volume
	audio_Player.stream = preload("res://sound effects/Enemy Hurt.wav")
	if play_sound:
		audio_Player.play()
	
	# play animation
	enemy_animated_sprite.play(enemy_dead_animation_name)
	enemy_animated_sprite.speed_scale = die_animation_speed
	yield(enemy_animated_sprite, "animation_finished")
	enemy_animated_sprite.visible = false
	
	if play_sound and audio_Player.playing: yield(audio_Player, "finished")
	
	queue_free()
	
# system functions
func _on_Edge_Detector_body_exited(body):
	# if is on edge, change the direction
	if body != self and body is TileMap:
		is_going_left = not is_going_left
		
func _physics_process(_delta):
	# if Player stomped enemy, damage the enemy
	if enemy_vunerable_area != null:
		if enemy_vunerable_area.overlaps_body(Player) and not Player.is_hurt and not is_dead:
			enemy_dead_animation_name = "die by stomp"
			die()
		
func _on_Deadly_Area_body_entered(body):
	# if Player touches enemy, damage the Player
	if body == Player and not Player.is_hurt:
		Player.jump_count = 0
		Player.jump()
		Player.take_damage()
