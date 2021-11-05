extends Enemy_Class

var player_in_range = false
var constantly_follow_player = false

func _ready():
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite
	enemy_dead_animation_name = "die by stomp"
	enemy_vunerable_area = $"Vunerable Area"

func _physics_process(_delta):
	if is_dead: return
	
	# if player in range, follow player. else, stop moving
	if player_in_range or constantly_follow_player: follow_object(player)
	else: vel = Vector2.ZERO

	# if bat hits player, damage the player and die
	if $"Deadly Area".overlaps_body(player) and not player.is_hurt:
		player.take_damage()
		die(false, false, false)
	
	move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded

# check if player is in range or not
func _on_Attack_Trigger_Area_body_entered(body):
	if body == player: player_in_range = true
func _on_Attack_Trigger_Area_body_exited(body):
	if body == player: player_in_range = false
