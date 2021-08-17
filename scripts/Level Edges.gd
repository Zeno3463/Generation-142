extends Area2D

onready var player = get_tree().get_root().get_node("/root/Player")
onready var camera = get_parent().get_node("Camera2D")

func _ready():
	connect("body_entered", self, "_on_player_entered")
	connect("body_exited", self, "_on_player_exited")

func _on_player_entered(body):
	if body == player: camera.dont_follow_player = true
		
func _on_player_exited(body):
	if body == player: camera.dont_follow_player = false
