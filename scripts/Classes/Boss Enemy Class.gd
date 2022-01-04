# all boss enemies will inherit this class

extends Enemy_Class

class_name Boss_Enemy_Class

export var life_count = 10
export(Array, NodePath) var doors_to_open = []
export(NodePath) var player_stuck_on_wall_handler = null

# node references
var life_bar: TextureProgress = null
var damage_animation_name = ""

# private variables
onready var life = life_count
onready var boss_dead_audio_Player = AudioStreamPlayer.new()
	
func _ready():
	boss_dead_audio_Player.volume_db = GlobalVariables.sound_volume
	life = life_count
	add_child(boss_dead_audio_Player)
	boss_dead_audio_Player.stream = preload("res://sound effects/Boss Dead.wav")
	if GlobalVariables.Player_has_entered_scene[get_tree().current_scene.filename] == true:
		boss_die(false)

func _process(_delta):
	# display the life count
	life_bar.value = life
	
	if life <= 0:
		boss_die()

func boss_take_damage():
	var audio_Player = AudioStreamPlayer.new()
	add_child(audio_Player)
	audio_Player.stream = preload("res://sound effects/Enemy Hurt.wav")
	audio_Player.volume_db = GlobalVariables.sound_volume
	audio_Player.play()
	life -= 1
	$AnimatedSprite.play(damage_animation_name)
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("default")
	yield(audio_Player, "finished")
	audio_Player.queue_free()

func boss_die(play_animation=true):
	if play_animation:
		die(true, true, false)
		
		# play sound
		if not boss_dead_audio_Player.playing: boss_dead_audio_Player.play()
	
	# notify the game that Player had already won the boss fight
	if get_tree().current_scene.filename != "res://scenes/Levels/The Grand Mansion/The Grand Mansion Section 3.tscn":
		GlobalVariables.Player_has_entered_scene[get_tree().current_scene.filename] = true
		GlobalVariables.save_game()
	
	# destroy the Player stuck on wall handler
	if player_stuck_on_wall_handler != null:
		get_node(player_stuck_on_wall_handler).queue_free()
		player_stuck_on_wall_handler = null

	# open up all the necessary doors after the Player killed the boss
	for door in doors_to_open:
		get_node(door).open()
		doors_to_open.pop_front()

	if not play_animation: queue_free()
