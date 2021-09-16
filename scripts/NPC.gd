extends AnimatedSprite

export(Array, String, MULTILINE) var content = null

onready var player = get_tree().get_root().get_node("/root/Player")
onready var dialogue_system = get_tree().get_root().get_node("/root/Ui")

func _process(_delta):
	# if the player interacts with the npc, display the content of the npc
	if $Label.visible and Input.is_action_just_pressed("interact") and not dialogue_system.is_displaying_dialogue:
		dialogue_system.display_the_dialogue(content)

func _on_Area2D_body_entered(body):
	# make the player able to interact with the npc
	if body == player:
		$Label.visible = true

func _on_Area2D_body_exited(body):
	# make the player unable to interact with the npc
	if body == player:
		$Label.visible = false
