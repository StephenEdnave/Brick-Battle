extends Node

var num_players = 0
var num_balls = 0

func change_scene(scene_path):
	print(scene_path)
	get_tree().change_scene(scene_path)