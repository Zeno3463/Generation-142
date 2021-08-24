# the player will inherit this class

extends KinematicBody2D

class_name Player_Class

# basic movement variables
export var speed = 70
export var jump_force = -150
export var gravity = 5
export var fall_gravity = 10
export var low_jump_gravity = 10
export var normal_animation_speed = 2

# double jump variables
export var double_jump_animation_speed = 4

# dash variables
export var dash_duration = 0.15
export var dash_multiplier = 4

# attack variables
export var attack_duration = 0.2
export var attack_animation_speed = 4
var enemies_that_are_in_the_attack_area = []

# hurt variables
export var hurt_duration = 1

# private variables
var vel = Vector2.ZERO
var jump_count = 0
var jump_count_limit = 2
var double_jump_animation_played = false
var dashed = false
var is_walking = false
var is_dashing = false
var is_attacking = false
var is_dead = false
var is_hurt = false

# can perform abilities
var can_double_jump = true
var can_dash = true
var can_attack = true

# node references
var player_animated_sprite = null
var attack_effect_animated_sprite = null
var attack_effect_parent = null
var attack_area = null
var trail_effect = null
var timer = null
onready var ui_controller = get_tree().get_root().get_node("/root/Ui")

# functions
func move_left():
	player_animated_sprite.flip_h = true
	attack_area.scale.x = -1
	attack_effect_parent.scale.x = -1
	vel.x = -speed
	is_walking = true
	
func move_right():
	player_animated_sprite.flip_h = false
	attack_area.scale.x = 1
	attack_effect_parent.scale.x = 1
	vel.x = speed
	is_walking = true
	
func stop_moving():
	vel.x = 0
	is_walking = false

func fall():
	if is_on_ceiling():
		vel.y = 0
	if is_on_floor():
		double_jump_animation_played = false
		jump_count = 0
		dashed = false
		vel.y = 0
		player_animated_sprite.speed_scale = normal_animation_speed
	elif vel.y > 0:
		vel.y += fall_gravity
	elif vel.y < 0 and not Input.is_action_pressed("ui_up"):
		vel.y += low_jump_gravity
	else:
		vel.y += gravity

func jump():
	vel.y = jump_force
	jump_count += 1

func load_animation():
	# this function will load the animation respective to the action
	# the player is performing at the current time
	if is_attacking:
		player_animated_sprite.play("attack")
		attack_effect_animated_sprite.visible = true
		attack_effect_animated_sprite.play("default")
		player_animated_sprite.speed_scale = attack_animation_speed
	elif jump_count == jump_count_limit and not double_jump_animation_played and can_double_jump:
		player_animated_sprite.play("double jump")
		player_animated_sprite.speed_scale = double_jump_animation_speed
	elif is_hurt:
		player_animated_sprite.play("damage")
	elif vel == Vector2.ZERO:
		player_animated_sprite.play("default")
	elif is_walking and vel.y == 0:
		player_animated_sprite.play("walk")
	elif vel.y > 5:
		player_animated_sprite.play("fall")
	elif vel.y < 0:
		player_animated_sprite.play("jump")
	
func reset_timer():
	# this function will reset all the value of the variables
	
	# this function is mainly used when a certain animation
	# is finished loaded
	trail_effect.visible = false
	attack_effect_animated_sprite.stop()
	attack_effect_animated_sprite.frame = 0
	attack_effect_animated_sprite.visible = false
	is_dashing = false
	is_attacking = false
	is_hurt = false
	attack_area.get_node("CollisionShape2D").disabled = true

func end_double_jump_animation():
	player_animated_sprite.speed_scale = normal_animation_speed
	double_jump_animation_played = true

func start_performing_an_action(action_name, action_duration):
	# this function is called when the player presses a certain button
	# that triggers an action
	
	set(action_name, true)
	timer.wait_time = action_duration
	timer.start()

func dash():
	vel.y = 0
	trail_effect.visible = true
	if player_animated_sprite.flip_h: vel.x = -speed * dash_multiplier
	else: vel.x = speed * dash_multiplier

func attack():
	attack_area.get_node("CollisionShape2D").disabled = false
	
func take_damage():
	ui_controller.take_out_one_life()
