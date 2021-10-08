extends Enemy_Class

func _ready():
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite
	enemy_dead_animation_name = "die by stomp"

func _physics_process(_delta):
	move_and_slide(vel) # warning-ignore:return_value_discarded

func _on_Area2D_body_entered(body):
	if body is TileMap:
		die(false)
	elif body == player:
		player.take_damage()
		die(false)