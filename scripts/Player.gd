extends KinematicBody2D

export var speed = 70
export var jump_force = -150
export var gravity = 5
export var fall_gravity = 10
export var low_jump_gravity = 10

var vel = Vector2.ZERO

func _physics_process(delta):
	# horizontal movement
	if Input.is_action_pressed("left"):
		$AnimatedSprite.flip_h = true
		vel.x = -speed
	elif Input.is_action_pressed("right"):
		$AnimatedSprite.flip_h = false
		vel.x = speed
	else: 
		vel.x = 0
	
	# falling
	if is_on_floor():
		vel.y = 0
	elif vel.y > 0:
		vel.y += fall_gravity
	elif vel.y < 0 and not Input.is_action_pressed("up"):
		vel.y += low_jump_gravity
	else:
		vel.y += gravity

	# jumping
	if Input.is_action_pressed("up") and is_on_floor():
		vel.y = jump_force
		
	# handle animation play
	if vel == Vector2.ZERO:
		$AnimatedSprite.play("default")
	elif vel.x != 0 and vel.y == 0:
		$AnimatedSprite.play("walk")
	elif vel.y > 5:
		$AnimatedSprite.play("fall")
	elif vel.y < 0:
		$AnimatedSprite.play("jump")

	move_and_slide(vel, Vector2.UP)
