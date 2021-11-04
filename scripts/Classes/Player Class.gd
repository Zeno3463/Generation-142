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
export var dash_vel_multiplier = 4

# attack variables
export var attack_duration = 0.2
export var attack_animation_speed = 4
var enemies_that_are_in_the_attack_area = []

# hurt variables
export var hurt_duration = 1

# power blast variables
export var power_blast_duration = 0.2
export var light_energy_while_blasting = 2
export var default_light_energy = 1

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
var is_power_blasting = false

# can perform abilities
onready var global_variables = get_tree().get_root().get_node("/root/GlobalVariables")

# node references
var player_animated_sprite: AnimatedSprite = null
var attack_effect_animated_sprite: AnimatedSprite = null
var attack_effect_parent: Node2D = null
var attack_area: Area2D = null
var trail_effect: Line2D = null
var timer: Timer = null
var camera: Camera2D = null
var power_blast_area: Area2D = null
var power_blast_particle_system: CPUParticles2D = null
var light: Light2D = null
var audio_player: AudioStreamPlayer = null
var jump_sound = null
var hurt_sound = null
var power_blast_sound = null
var attack_sound = null
var dash_sound = null
onready var ui_controller = get_tree().get_root().get_node("/root/Ui")

# public functions
func move_left():
	vel.x = -speed
	is_walking = true
	_flip_player_sprite_to_face_the_direction_it_is_moving()
	
func move_right():
	vel.x = speed
	is_walking = true
	_flip_player_sprite_to_face_the_direction_it_is_moving()
	
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

func jump(play_sound = true):
	is_dashing = false
	dashed = false
	vel.y = jump_force
	jump_count += 1
	if play_sound:
		audio_player.stream = jump_sound
		audio_player.play()

func load_animation_according_to_current_action():
	if is_attacking:
		player_animated_sprite.play("attack")
		attack_effect_animated_sprite.visible = true
		attack_effect_animated_sprite.play("default")
		player_animated_sprite.speed_scale = attack_animation_speed
	elif is_power_blasting:
		player_animated_sprite.play("power blast")
	elif jump_count == jump_count_limit and not double_jump_animation_played and global_variables.can_double_jump:
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
	
func reset_everything_to_default():
	light.energy = default_light_energy
	trail_effect.visible = false
	attack_effect_animated_sprite.stop()
	attack_effect_animated_sprite.frame = 0
	attack_effect_animated_sprite.visible = false
	is_dashing = false
	is_attacking = false
	is_hurt = false
	is_power_blasting = false
	attack_area.get_node("CollisionShape2D").call_deferred("set", "disabled", true)

func end_double_jump_animation():
	player_animated_sprite.speed_scale = normal_animation_speed
	double_jump_animation_played = true

func start_performing_an_action(action_name, action_duration):
	# this function is called when the player presses a certain button
	# that triggers an action
	
	set(action_name, true)
	timer.wait_time = action_duration
	timer.start()

func power_blast():
	vel = Vector2.ZERO
	camera.start()
	light.energy = light_energy_while_blasting
	power_blast_particle_system.emitting = true
	
	# get all the areas and bodies in the player's pov
	# destroy all areas and bodies that belong to enemies
	var areas = power_blast_area.get_overlapping_areas()
	for area in areas:
		if area.name == "Fireball Area":
			area.get_parent().die(false)
	var bodies = power_blast_area.get_overlapping_bodies()
	for body in bodies:
		if body is Enemy_Class and not body is Boss_Enemy_Class and not body.is_dead:
			body.die(false)
	
	# cut down the player's life by a half
	while ui_controller.get_node("Lives").get_child_count() > 3:
		ui_controller.take_out_one_life()
	
	# play power blast sound effects
	if not audio_player.playing:
		audio_player.stream = power_blast_sound
		audio_player.play()

func dash():
	vel.y = 0
	trail_effect.visible = true
	if player_animated_sprite.flip_h: vel.x = -speed * dash_vel_multiplier
	else: vel.x = speed * dash_vel_multiplier

func attack():
	attack_area.get_node("CollisionShape2D").disabled = false
	
func take_damage():
	camera.start()
	reset_everything_to_default()
	ui_controller.take_out_one_life()
	start_performing_an_action("is_hurt", hurt_duration)
	audio_player.stream = hurt_sound
	audio_player.play()
	
# private functions
func _flip_player_sprite_to_face_the_direction_it_is_moving():
	var is_moving_right = vel.x > 0
	if is_moving_right:
		player_animated_sprite.flip_h = false
		attack_area.scale.x = 1
		attack_effect_parent.scale.x = 1
	else:
		player_animated_sprite.flip_h = true
		attack_area.scale.x = -1
		attack_effect_parent.scale.x = -1
		
# system functions
func _on_AnimatedSprite_animation_finished():
	if str($AnimatedSprite.animation) == "double jump":
		end_double_jump_animation()

func _on_Timer_timeout():
	reset_everything_to_default()

func _on_Vunerable_Area_body_entered(body):
	# if enemy hits player, damage the player
	if body is Enemy_Class and not is_hurt and not is_dead and not body.is_dead:
		take_damage()

func _on_Attack_Area_body_entered(body):
	# if player hits enemy, damage the enemy
	if body is Enemy_Class and not body is Boss_Enemy_Class:
		body.enemy_dead_animation_name = "die by hit"
		body.die()
		
	elif body is Crate_Class:
		body.explode()
