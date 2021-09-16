# all boss enemies will inherit this class

extends Enemy_Class

class_name Boss_Enemy_Class

export var life_count = 10
export(Array, NodePath) var doors_to_open = []

# node references
var life_bar: TextureProgress = null
var damage_animation_name = ""

# private variables
onready var life = life_count
	
func _ready():
	life = life_count
	
func _process(_delta):
	# display the life count
	life_bar.value = life
	
	if life <= 0:
		boss_die()

func boss_take_damage():
	life -= 1
	$AnimatedSprite.play(damage_animation_name)
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("default")

func boss_die():
	die()
	# open up all the necessary doors after the player killed the boss
	for door in doors_to_open:
		get_node(door).open()
		doors_to_open.pop_front()
