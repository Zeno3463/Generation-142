extends Enemy_Class

func _ready():
	# initialize node references
	enemy_animated_sprite = $AnimatedSprite
	enemy_dead_animation_name = "die by stomp"
	enemy_vunerable_area = $"Vunerable Area"
	
	# connect the signals
	$"Edge Detector".connect("body_exited", self, "_on_Edge_Detector_body_exited") # warning-ignore:return_value_discarded

func _physics_process(_delta):
	if is_dead: return
	if is_going_left:
		$"Edge Detector".scale.x = -1
		move_left()
	else: 
		$"Edge Detector".scale.x = 1
		move_right()
	
	fall()
	
	move_and_slide(vel, Vector2.UP) # warning-ignore:return_value_discarded
