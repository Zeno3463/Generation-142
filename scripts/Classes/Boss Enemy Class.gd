# all boss enemies will inherit this class

extends Enemy_Class

class_name Boss_Enemy_Class

export var life_count = 10
export(Array, NodePath) var doors_to_open = []
export(NodePath) var player_stuck_on_wall_handler = null

# node references
var life_bar: TextureProgress = null
var damage_animation_name = ""
onready var global_variables = get_tree().get_root().get_node("/root/GlobalVariables")

# private variables
onready var life = life_count
onready var boss_dead_audio_player = AudioStreamPlayer.new()
	
func _ready():
	life = life_count
	add_child(boss_dead_audio_player)
	boss_dead_audio_player.stream = preload("res://sound effects/Boss Dead.wav")
	
func _process(_delta):
	# display the life count
	life_bar.value = life
	
	if life <= 0:
		boss_die()

func boss_take_damage():
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = preload("res://sound effects/Enemy Hurt.wav")
	audio_player.play()
	life -= 1
	$AnimatedSprite.play(damage_animation_name)
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("default")
	yield(audio_player, "finished")
	audio_player.queue_free()

func boss_die():
	die(true, true, false)
	
	# play sound
	if not boss_dead_audio_player.playing: boss_dead_audio_player.play()
	
	# notify the game that player had already won the boss fight
	global_variables.player_has_entered_scene[get_tree().current_scene.filename] = true
	global_variables.save_game()
	
	# destroy the player stuck on wall handler
	if player_stuck_on_wall_handler != null:
		get_node(player_stuck_on_wall_handler).queue_free()
		player_stuck_on_wall_handler = null

	# open up all the necessary doors after the player killed the boss
	for door in doors_to_open:
		get_node(door).open()
		doors_to_open.pop_front()
