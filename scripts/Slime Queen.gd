extends Enemy_Class

export var dash_duration = 1
export var dash_speed = 120
export var time_btw_dash = 5
onready var normal_speed = speed
onready var player = get_tree().get_root().get_node("/root/Player")
var is_dashing = false

func _ready():
	randomize()
	
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite
	enemy_dead_animation_name = "die by stomp"
	
	# start the dash timer
	$Timer.start()

func _physics_process(delta):
	# change the direction of movement when it is on wall
	if is_on_ceiling() or is_on_floor() or is_on_wall():
		dir = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	
	if is_dashing:
		follow_object(player)
		speed = dash_speed
	else:
		move_diagonal()
		speed = normal_speed
	
	move_and_slide(vel, Vector2.UP)

# system functions
func _on_Timer_timeout():
	# start the countdown timer for dashing
	if is_dashing:
		is_dashing = false
		$Timer.wait_time = time_btw_dash
		$Timer.start()
	else:
		is_dashing = true
		$Timer.wait_time = dash_duration
		$Timer.start()

func _on_Vunerable_Area_body_entered(body):
	if body == player:
		player.jump()
