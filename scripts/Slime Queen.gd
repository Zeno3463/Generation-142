extends Boss_Enemy_Class

# basic movement variables
export var dash_duration = 1
export var dash_speed = 120
export var time_btw_dash = 5

# private variables
onready var normal_speed = speed
var is_dashing = false

func _ready():
	randomize()
	
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite
	enemy_dead_animation_name = "dead"
	damage_animation_name = "damage"
	life_bar = $"CanvasLayer/Life Count"
	
	# set the max value of the life count
	life_bar.max_value = life_count
	
	# start the dash timer
	$Timer.start()

func _physics_process(_delta):
	if is_dead: return
	
	if is_dashing:
		follow_object(Player)
		speed = dash_speed
	else:
		move_diagonal()
		speed = normal_speed
		
	move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded

# system functions
func _on_Timer_timeout():
	# if the timer ran out of time
	
	# if the enemy is dashing, stop dashing and reset the timer
	if is_dashing:
		is_dashing = false
		$Timer.wait_time = time_btw_dash
		$Timer.start()
		
	# if the enemy is not dashing, start dashing and reset the timer
	else:
		is_dashing = true
		$Timer.wait_time = dash_duration
		$Timer.start()

func _on_Vunerable_Area_body_entered(body):
	# if Player stomped the enemy, damage the enemy
	if body == Player and not Player.is_hurt and not is_dashing:
		boss_take_damage()
