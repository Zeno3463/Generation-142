extends Boss_Enemy_Class

# private variables
var special_attack_num = 1

# special attack 1 variables
var bat_reference = preload("res://scenes/Enemies/Under Cave/Bat.tscn")
onready var positions = $"Special Attack 1".get_children()

# special attack 2 variables
var fireball_reference = preload("res://scenes/Enemies/Under Cave/Fire Ball.tscn")
export var fireball_num = 6

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
	
	if not Player.is_hurt:
		follow_object(Player)
	
		move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded

func _on_Timer_timeout():
	if is_dead: return
	enemy_animated_sprite.play("cast spell")
	yield(enemy_animated_sprite, "animation_finished")
	match special_attack_num:
		1: special_attack_1()
		2: special_attack_2()
	special_attack_num += 1
	if special_attack_num >= 3: special_attack_num = 1
	enemy_animated_sprite.play("default")

func _on_Vunerable_Area_body_entered(body):
	# if Player stomped the enemy, damage the enemy
	if body == Player and not Player.is_hurt:
		boss_take_damage()
		
func special_attack_1():
	for position in positions:
		var bat_instance = bat_reference.instance()
		bat_instance.global_position = position.global_position
		bat_instance.constantly_follow_Player = true
		get_parent().add_child(bat_instance)
		
func special_attack_2():
	for angle in range(0, 360, int(360/fireball_num)):
		var fireball_instance = fireball_reference.instance()
		fireball_instance.global_position = global_position
		fireball_instance.vel = Vector2(cos(angle), sin(angle)).normalized() * fireball_instance.speed
		get_parent().add_child(fireball_instance)
