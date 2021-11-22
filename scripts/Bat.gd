extends Enemy_Class

var Player_in_range = false
var constantly_follow_Player = false

func _ready():
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite
	enemy_dead_animation_name = "die by stomp"
	enemy_vunerable_area = $"Vunerable Area"

func _physics_process(_delta):
	if is_dead: return
	
	# if Player in range, follow Player. else, stop moving
	if Player_in_range or constantly_follow_Player: follow_object(Player)
	else: vel = Vector2.ZERO

	# if bat hits Player, damage the Player and die
	if $"Deadly Area".overlaps_body(Player):
		if not Player.is_hurt:
			Player.take_damage()
		die(false, false, false)
	
	move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded

# check if Player is in range or not
func _on_Attack_Trigger_Area_body_entered(body):
	if body == Player: Player_in_range = true
func _on_Attack_Trigger_Area_body_exited(body):
	if body == Player: Player_in_range = false
