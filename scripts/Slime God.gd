extends Boss_Enemy_Class

# special attack variables
var fireball_reference = preload("res://scenes/Enemies/Garden Of Poison/Fire Ball 2.tscn")
export var fireball_num_min = 3
export var fireball_num_max = 6

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
	
	move_diagonal()
	
	move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded

func _on_Timer_timeout():
	if is_dead: return
	enemy_animated_sprite.play("attack")
	yield(enemy_animated_sprite, "animation_finished")
	special_attack()
	enemy_animated_sprite.play("default")

func _on_Vunerable_Area_body_entered(body):
	# if player stomped the enemy, damage the enemy
	if body == player and not player.is_hurt:
		boss_take_damage()

func special_attack():
	for angle in range(0, 360, int(360/rand_range(fireball_num_min, fireball_num_max))):
		var fireball_instance = fireball_reference.instance()
		fireball_instance.global_position = global_position
		fireball_instance.vel = Vector2(cos(angle), sin(angle)).normalized() * fireball_instance.speed
		get_parent().add_child(fireball_instance)
