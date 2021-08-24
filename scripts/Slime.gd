extends Enemy_Class

var is_going_left = true
onready var player = get_tree().get_root().get_node("/root/Player")

func _ready():
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite
	enemy_dead_animation_name = "die by stomp"

func _physics_process(delta):
	# horizontal movement
	if is_going_left:
		$"Edge Detector".scale.x = -1
		move_left()
	else: 
		$"Edge Detector".scale.x = 1
		move_right()
	
	fall()
	
	move_and_slide(vel, Vector2.UP)

# system functions
func _on_Edge_Detector_body_exited(body):
	# if enemy is on edge, switch the direction of movement
	if not body is Enemy_Class:
		is_going_left = not is_going_left

func _on_Vunerable_Area_body_entered(body):
	# if the player hits the enemy, destroy the enemy
	if body == player and not player.is_hurt:
		player.jump()
		die()
