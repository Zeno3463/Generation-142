extends KinematicBody2D

class_name Enemy_Class

# basic movement
export var speed = 30
export var jump_force = -150
export var gravity = 5
export var die_animation_speed = 3

# private variables
var vel = Vector2.ZERO

# node references
var enemy_animated_sprite = null
var enemy_dead_animation_name = ""

# functions
func move_left():
	enemy_animated_sprite.flip_h = true
	vel.x = -speed
	
func move_right():
	enemy_animated_sprite.flip_h = false
	vel.x = speed
	
func fall():
	if is_on_floor():
		vel.y = 0
	else:
		vel.y += gravity
		
func die():
	enemy_animated_sprite.play(enemy_dead_animation_name)
	enemy_animated_sprite.speed_scale = die_animation_speed
	yield(enemy_animated_sprite, "animation_finished")
	queue_free()
