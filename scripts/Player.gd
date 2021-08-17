extends KinematicBody2D

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

func _physics_process(_delta):
	# horizontal movement
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite.flip_h = true
		vel.x = -speed
		is_walking = true
	elif Input.is_action_pressed("ui_right"):
		$AnimatedSprite.flip_h = false
		vel.x = speed
		is_walking = true
	else: 
		vel.x = 0
		is_walking = false
	
	# falling
	if is_on_floor() or is_on_ceiling():
		double_jump_animation_played = false
		jump_count = 0
		dashed = false
		vel.y = 0
		$AnimatedSprite.speed_scale = normal_animation_speed
	elif vel.y > 0:
		vel.y += fall_gravity
	elif vel.y < 0 and not Input.is_action_pressed("ui_up"):
		vel.y += low_jump_gravity
	else:
		vel.y += gravity

	# jumping
	if Input.is_action_just_pressed("ui_up") and jump_count < jump_count_limit:
		vel.y = jump_force
		jump_count += 1
		
	# double jump
	if can_double_jump:
		jump_count_limit = 2
	else:
		jump_count_limit = 1
		
	# dash
	if can_dash and Input.is_action_just_pressed("dash") and not is_dashing and not dashed:
		dashed = true
		start_performing_an_action("is_dashing", dash_duration)
	if is_dashing: dash()
		
	# attack
	if can_attack and Input.is_action_just_pressed("attack"):
		start_performing_an_action("is_attacking", attack_duration)
	if is_attacking: attack()
		
	# handle animation play
	if is_attacking:
		$AnimatedSprite.play("attack")
		$AnimatedSprite.speed_scale = attack_animation_speed
	elif jump_count == jump_count_limit and not double_jump_animation_played and can_double_jump:
		$AnimatedSprite.play("double jump")
		$AnimatedSprite.speed_scale = double_jump_animation_speed
	elif vel == Vector2.ZERO:
		$AnimatedSprite.play("default")
	elif is_walking and vel.y == 0:
		$AnimatedSprite.play("walk")
	elif vel.y > 5:
		$AnimatedSprite.play("fall")
	elif vel.y < 0:
		$AnimatedSprite.play("jump")

	move_and_slide(vel, Vector2.UP)

# private functions
func start_performing_an_action(action_name, action_duration):
	set(action_name, true)
	$Timer.wait_time = action_duration
	$Timer.start()

func dash():
	vel.y = 0
	$Effects/Trail/Line2D.visible = true
	if $AnimatedSprite.flip_h: vel.x = -speed * dash_multiplier
	else: vel.x = speed * dash_multiplier

func attack():
	pass

# system functions
func _on_AnimatedSprite_animation_finished():
	if str($AnimatedSprite.animation) == "double jump":
		$AnimatedSprite.speed_scale = normal_animation_speed
		double_jump_animation_played = true

func _on_Timer_timeout():
	$Effects/Trail/Line2D.visible = false
	is_dashing = false
	is_attacking = false
