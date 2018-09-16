extends Control

var _world = load("res://levels/World.tscn")

func _ready():
	$UI/MessageLabel.text = "Breakout Battle"
	$UI/MainMenu.show()


func _on_StartButton_button_down():
	get_tree().change_scene("res://levels/World.tscn")

func _on_ExitButton_button_down():
	get_tree().quit()
