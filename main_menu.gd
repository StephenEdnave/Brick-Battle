extends Node2D

var _world = load("res://levels/World.tscn")

func _ready():
	$UI/MessageLabel.text = "Breakout Battle"
	$UI/MainMenu.show()


func _on_StartButton_button_down():
	var world = _world.instance()
	get_parent().add_child(world)
	Utils.world = world
	world.new_game()
	queue_free()