extends Boss_Enemy_Class

# basic movement variables
export var time_btw_attack: float = 1
export var attack_move_speed = 30
export var attack_animation_speed = 2
export var attack_count_before_rest = 5
export var rest_time = 3

# private variables
var is_attacking = false
var is_resting = false
var jumped = false
onready var normal_animation_speed = $AnimatedSprite.speed_scale
var curr_Player_x_pos = 0
var attack_count = 0

func _ready():
	randomize()
	
	# start the timer
	$Timer.wait_time = time_btw_attack
	$Timer.start()
	
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite
	enemy_dead_animation_name = "dead"
	damage_animation_name = "damage"
	life_bar = $"CanvasLayer/Life Count"
	
	# set the max value of the life count
	life_bar.max_value = life_count
	
	# set the rest timer wait time
	$"Rest Timer".wait_time = rest_time

func _physics_process(_delta):
	if is_dead: return
	
	if is_on_ceiling(): vel.y = 0
	
	# if death skull is tired, let the death skull rest
	if attack_count >= attack_count_before_rest:
		stop_moving()
		rest()
	else:
		# else if the death skull is ready to attack the Player, attack Player
		if is_attacking:
			use_special_attack()
		# else, walk towards the Player
		else:
			if not is_on_floor(): fall()
			if position.x > Player.global_position.x:
				move_left()
			elif global_position.x < Player.global_position.x:
				move_right()
			else:
				stop_moving()
		
	move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded

func _on_Vunerable_Area_body_entered(body):
	# if Player stomped the enemy, damage the enemy
	if body == Player and not Player.is_hurt:
		boss_take_damage()

func _on_Timer_timeout():
	# if the timer ran out of time, start the special attack
	is_attacking = true
	attack_count += 1
	curr_Player_x_pos = Player.global_position.x
	$Timer.stop()
	
func rest():
	is_resting = true
	
	# let death skull be vunerable
	$"Attack Area/CollisionShape2D".disabled = true
	$"Vunerable Area/CollisionShape2D".disabled = false
	
	# set the animation
	if enemy_animated_sprite.animation != "damage": enemy_animated_sprite.play("rest")
	
	# start the rest timer if it is not started yet
	if $"Rest Timer".time_left <= 0: $"Rest Timer".start()
	
func use_special_attack():
	# follow Player
	if not jumped:
		jump_onto_object(Vector2(curr_Player_x_pos, 0), attack_move_speed)
	
	# jump
	if is_on_floor():
		if not jumped:
			# change animated sprite
			enemy_animated_sprite.play("jump")
			
			jump()
			jumped = true
		else:
			stop_moving()
			enemy_animated_sprite.speed_scale = attack_animation_speed
			enemy_animated_sprite.play("attack")
			yield(enemy_animated_sprite, "animation_finished")
			is_attacking = false
			jumped = false
			$Timer.start()
			enemy_animated_sprite.play("default")
			enemy_animated_sprite.speed_scale = normal_animation_speed
	else:
		fall()
	
func _on_Attack_Area_body_entered(body):
	if body == Player:
		Player.take_damage()

func _on_Rest_Timer_timeout():
	attack_count = 0
	is_resting = false
	
	# let death skull be invincible
	$"Attack Area/CollisionShape2D".disabled = false
	$"Vunerable Area/CollisionShape2D".disabled = true

	# reset the animation
	enemy_animated_sprite.play("default")

	$"Rest Timer".stop()
