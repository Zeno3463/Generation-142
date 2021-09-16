extends Enemy_Class

func _ready():
	enemy_animated_sprite = $AnimatedSprite

func _physics_process(_delta):
	if is_going_left:
		move_left()
	else: 
		move_right()
	
	move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded

func _on_Area2D_body_entered(body):
	if body is TileMap or body is Player_Class:
		queue_free()
