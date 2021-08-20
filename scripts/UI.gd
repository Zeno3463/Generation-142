extends CanvasLayer

export var lives = 5
export var heart_sprite_size = 40
export var margin_btw_heart_sprites = 10
var heart_sprite = preload("res://sprites/UIs/Heart.png")
onready var curr_live_count = lives

func _ready():
	for i in len(range(lives)):
		var heart_texture = TextureRect.new()
		heart_texture.texture = heart_sprite
		heart_texture.expand = true
		heart_texture.rect_size = Vector2.ONE * 40
		heart_texture.rect_position.x = i * (heart_sprite_size + margin_btw_heart_sprites)
		$Lives.add_child(heart_texture)
		
func take_out_one_life():
	curr_live_count -= 1
	$Lives.remove_child($Lives.get_child($Lives.get_child_count()-1))
