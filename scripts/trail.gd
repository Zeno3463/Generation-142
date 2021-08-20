extends Line2D

onready var point = get_parent().global_position
var leave_tracks = true
export var trail_length = 10

func _ready():
	set_as_toplevel(true)

func _physics_process(_delta):
	if leave_tracks:
		point = get_parent().global_position
		add_point(point)
		if points.size() > trail_length:
			remove_point(0)
	else:
		if points.size():
			remove_point(0)
