extends Enemy_Class

var Player_in_range = false
var jumped = false

func _ready():
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite
	enemy_dead_animation_name = "die by stomp"
	enemy_vunerable_area = $"Vunerable Area"

func _physics_process(_delta):
	if is_dead: return
	
	if Player_in_range and not jumped:
		jump_onto_object(Player.global_position, speed)
	
	# change animated sprite
	if not Player_in_range:
		enemy_animated_sprite.play("default")
	elif vel.y < 0:
		enemy_animated_sprite.play("jump")
	else:
		enemy_animated_sprite.play("fall")

	if is_on_ceiling():
		vel.y = 0

	if is_on_floor():
		if not jumped and Player_in_range:
			jump()
			jumped = true
		else:
			stop_moving()
			jumped = false
	else:
		fall()
		
	move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded

func _on_Attack_Trigger_Area_body_entered(body):
	if body == Player:
		Player_in_range = true

func _on_Attack_Trigger_Area_body_exited(body):
	if body == Player:
		Player_in_range = false
