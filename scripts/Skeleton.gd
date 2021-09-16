extends Enemy_Class

export var projectile_speed = 80

var is_attacking = false
var projectile = preload("res://scenes/Enemies/Abandoned Village/Arrow.tscn")

func _ready():
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite
	enemy_dead_animation_name = "die by stomp"
	enemy_shoot_animation_name = "shoot"
	
	# connect the signals
	$"Edge Detector".connect("body_exited", self, "_on_Edge_Detector_body_exited") # warning-ignore:return_value_discarded
	$"Vunerable Area".connect("body_entered", self, "_on_Vunerable_Area_body_entered") # warning-ignore:return_value_discarded
	$"Deadly Area".connect("body_entered", self, "_on_Deadly_Area_body_entered") # warning-ignore:return_value_discarded

func _physics_process(_delta):
	if is_dead: return
	
	if not is_attacking:
		if is_going_left:
			$"Edge Detector".scale.x = -1
			$"Attack Trigger Area".scale.x = -1
			move_left()
		else: 
			$"Edge Detector".scale.x = 1
			$"Attack Trigger Area".scale.x = 1
			move_right()
	elif can_shoot:
		shoot()
		stop_moving()
	
	fall()
	
	move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded

func shoot():
	enemy_animated_sprite.play(enemy_shoot_animation_name)
	var projectile_instance = projectile.instance()
	get_parent().add_child(projectile_instance)
	projectile_instance.speed = projectile_speed
	projectile_instance.global_position = global_position
	projectile_instance.is_going_left = is_going_left
	can_shoot = false
	$Timer.start()

func _on_Attack_Trigger_Area_body_entered(body):
	# if player triggers the attack area, start attacking the player
	if body == player and not is_dead:
		is_attacking = true

func _on_Attack_Trigger_Area_body_exited(body):
	# if player leaves the attack area, stop attacking the player
	if body == player and not is_dead:
		enemy_animated_sprite.play("default")
		is_attacking = false
		
func _on_Timer_timeout():
	$Timer.stop()
	can_shoot = true
