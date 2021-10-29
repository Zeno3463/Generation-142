extends Node2D

var player_has_entered_scene = {
	"res://scenes/Levels/Blue Forest/Blue Forest Section 3.tscn": false,
	"res://scenes/Levels/Abandoned Village/Abandoned Village Section 3.tscn": false,
	"res://scenes/Levels/Garden Of Poison/Garden Of Poison Section 3.tscn": false,
	"res://scenes/Levels/Under Cave/Under Cave Section 2.tscn": false
}

# can perform abilities
var can_double_jump = true
var can_dash = true
var can_attack = true
var can_power_blast = true

# map
var curr_section_path = "res://scenes/Levels/Blue Forest/Blue Forest Section 0.tscn"
var visited_section = ["res://scenes/Levels/Blue Forest/Blue Forest Section 0.tscn"]
