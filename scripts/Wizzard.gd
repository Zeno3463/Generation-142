extends Enemy_Class

export var time_btw_cast = 1

var Player_in_range = false
var bat_reference = preload("res://scenes/Enemies/Under Cave/Bat.tscn")

func _ready():
	# setup the timer
	$Timer.wait_time = time_btw_cast
	$Timer.start()
	
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite
	enemy_dead_animation_name = "die by stomp"
	
	# connect the signals
	$"Deadly Area".connect("body_entered", self, "_on_Deadly_Area_body_entered") # warning-ignore:return_value_discarded

func _physics_process(_delta):
	if is_dead: return
	
	if Player_in_range:
		enemy_animated_sprite.play("cast")
	else:
		enemy_animated_sprite.play("default")

func _on_Timer_timeout():
	# if timeout and Player is in range
	if Player_in_range:
		# spawn a bat
		var bat_instance = bat_reference.instance()
		bat_instance.global_position = global_position
		get_parent().add_child(bat_instance)
	
# check if the Player is in range
func _on_Attack_Trigger_Area_body_entered(body):
	if body == Player: Player_in_range = true
func _on_Attack_Trigger_Area_body_exited(body):
	if body == Player: Player_in_range = false

