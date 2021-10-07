extends Enemy_Class

func _ready():
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite

func _physics_process(_delta):
	if is_going_left:
		move_left()
	else: 
		move_right()
	
	move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded

func _on_Area2D_body_entered(body):
	# if the arrow hits the player, damage the player and queue free
	if body is Player_Class:
		body.take_damage()
		queue_free()
	# if the arrow hits the wall, queue free
	elif body is TileMap:
		queue_free()
