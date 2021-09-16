extends Player_Class

func _ready():
	# initialize node references
	player_animated_sprite = $AnimatedSprite
	attack_effect_animated_sprite = $Effects/Attack/AnimatedSprite
	attack_effect_parent = $Effects/Attack
	attack_area = $"Attack Area"
	trail_effect = $Effects/Dash/Line2D
	timer = $Timer
	
	# connect the signals
	$"Attack Area".connect("body_entered", self, "_on_Attack_Area_body_entered") # warning-ignore:return_value_discarded
	$"Vunerable Area".connect("body_entered", self, "_on_Vunerable_Area_body_entered") # warning-ignore:return_value_discarded
	$Timer.connect("timeout", self, "_on_Timer_timeout") # warning-ignore:return_value_discarded
	$AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished") # warning-ignore:return_value_discarded

func _physics_process(_delta):
	if is_dead: return
	
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
	if is_on_wall():
		is_dashing = false
	if can_dash and Input.is_action_just_pressed("dash") and not is_dashing and not dashed:
		dashed = true
		start_performing_an_action("is_dashing", dash_duration)
	if is_dashing: dash()
	else: trail_effect.visible = false
		
	# attack
	if can_attack and Input.is_action_just_pressed("attack"):
		start_performing_an_action("is_attacking", attack_duration)
	if is_attacking: attack()
		
	load_animation_according_to_current_action()
	move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded
