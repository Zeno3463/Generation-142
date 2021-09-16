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

# functions
func move_left():
	enemy_animated_sprite.flip_h = true
	vel.x = -speed
	
func move_right():
	enemy_animated_sprite.flip_h = false
	vel.x = speed
	
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
	
func fall():
	if is_on_floor():
		vel.y = 0
	else:
		vel.y += gravity
	
func die():
	is_dead = true
	ui_controller.num_of_hits += 1
	enemy_animated_sprite.play(enemy_dead_animation_name)
	enemy_animated_sprite.speed_scale = die_animation_speed
	yield(enemy_animated_sprite, "animation_finished")
	queue_free()
	
# system functions
func _on_Edge_Detector_body_exited(body):
	# if is on edge, change the direction
	if body != self:
		is_going_left = not is_going_left

func _on_Vunerable_Area_body_entered(body):
	# if player stomped enemy, damage the enemy
	if body == player and not player.is_hurt:
		enemy_dead_animation_name = "die by stomp"
		player.jump_count = 0
		player.jump()
		die()
		
func _on_Deadly_Area_body_entered(body):
	# if player stomped enemy, damage the enemy
	if body == player and not player.is_hurt:
		player.jump_count = 0
		player.jump()
		player.take_damage()
