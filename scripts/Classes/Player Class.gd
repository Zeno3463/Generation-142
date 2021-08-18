extends KinematicBody2D

class_name Player_Class

# basic movement
export var speed = 70
export var jump_force = -150
export var gravity = 5
export var fall_gravity = 10
export var low_jump_gravity = 10

# double jump
export var double_jump_animation_speed = 4
export var normal_animation_speed = 2

# dash
export var dash_duration = 0.15
export var dash_multiplier = 4

# attack
export var attack_duration = 0.2
export var attack_animation_speed = 4

# private variables
var vel = Vector2.ZERO
var jump_count = 0
var jump_count_limit = 2
var double_jump_animation_played = false
var dashed = false
var is_walking = false
var is_dashing = false
var is_attacking = false

# can perform abilities
var can_double_jump = true
var can_dash = true
var can_attack = true

# node references
var player_animated_sprite = null
var attack_effect_animated_sprite = null
var attack_effect_parent = null
var trail_effect = null

# functions
func move_left():
	player_animated_sprite.flip_h = true
	attack_effect_parent.scale.x = -1
	vel.x = -speed
	is_walking = true
	
func move_right():
	player_animated_sprite.flip_h = false
	attack_effect_parent.scale.x = 1
	vel.x = speed
	is_walking = true
	
func stop_moving():
	vel.x = 0
	is_walking = false

func fall():
	if is_on_floor() or is_on_ceiling():
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
	if is_attacking:
		player_animated_sprite.play("attack")
		attack_effect_animated_sprite.visible = true
		attack_effect_animated_sprite.play("default")
		player_animated_sprite.speed_scale = attack_animation_speed
	elif jump_count == jump_count_limit and not double_jump_animation_played and can_double_jump:
		player_animated_sprite.play("double jump")
		player_animated_sprite.speed_scale = double_jump_animation_speed
	elif vel == Vector2.ZERO:
		player_animated_sprite.play("default")
	elif is_walking and vel.y == 0:
		player_animated_sprite.play("walk")
	elif vel.y > 5:
		player_animated_sprite.play("fall")
	elif vel.y < 0:
		player_animated_sprite.play("jump")
	
func reset_timer():
	trail_effect.visible = false
	attack_effect_animated_sprite.stop()
	attack_effect_animated_sprite.frame = 0
	attack_effect_animated_sprite.visible = false
	is_dashing = false
	is_attacking = false

func end_double_jump_animation():
	if str($AnimatedSprite.animation) == "double jump":
		$AnimatedSprite.speed_scale = normal_animation_speed
		double_jump_animation_played = true

func start_performing_an_action(action_name, action_duration):
	set(action_name, true)
	$Timer.wait_time = action_duration
	$Timer.start()

func dash():
	vel.y = 0
	$Effects/Dash/Line2D.visible = true
	if $AnimatedSprite.flip_h: vel.x = -speed * dash_multiplier
	else: vel.x = speed * dash_multiplier

func attack():
	pass
