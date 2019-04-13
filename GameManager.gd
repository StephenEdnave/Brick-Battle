extends Node

var num_players = 0
var num_balls = 0
var num_controllers = 0

var PlayerColors = {
	1 : Color(0.2,0.4,1, 1),
	2 : Color(1, 0.2, 0.2, 1),
	3 : Color(0.2, 1, 0.2, 1),
	4 : Color(1, 1, 0.3, 1)
}

func _ready():
	OS.window_fullscreen = true
#	OS.window_size = Vector2(1280, 720)

func change_scene(scene_path):
	print(scene_path)
	get_tree().change_scene(scene_path)