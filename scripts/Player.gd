extends Player_Class

func _ready():
	# initialize node references
	player_animated_sprite = $AnimatedSprite
	attack_effect_animated_sprite = $Effects/Attack/AnimatedSprite
	attack_effect_parent = $Effects/Attack
	trail_effect = $Effects/Dash/Line2D
	timer = $Timer

func _physics_process(_delta):
	# horizontal movement
	if Input.is_action_pressed("ui_left"):
		move_left()
	elif Input.is_action_pressed("ui_right"):
		move_right()
	else: 
		stop_moving()
		
	fall()
		
	# jumping
	if Input.is_action_just_pressed("ui_up") and jump_count < jump_count_limit:
		jump()
		
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
		
	load_animation()
	move_and_slide(vel, Vector2.UP)

# system functions
func _on_AnimatedSprite_animation_finished():
	if str($AnimatedSprite.animation) == "double jump":
		end_double_jump_animation()

func _on_Timer_timeout():
	reset_timer()

func _on_Vunerable_Area_body_entered(body):
	# if enemy hits player, damage the player
	if body is Enemy_Class:
		take_damage()
