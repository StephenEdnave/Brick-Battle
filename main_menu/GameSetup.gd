extends Control

func _ready():
	$UI/Buttons/Players.visible = true
	$UI/Buttons/Balls.visible = false
	for i in range($UI/Buttons/Players.get_child_count()):
		$UI/Buttons/Players.get_child(i).connect("button_down", self, "_on_player_button_down", [i + 1])
	for i in range($UI/Buttons/Balls.get_child_count()):
		$UI/Buttons/Balls.get_child(i).connect("button_down", self, "_on_ball_button_down", [i + 1])
	$UI/Buttons/ReturnButton.connect("button_down", self, "_on_return_button_down")
	
	$UI/Buttons/Players.get_child(0).grab_focus()


func _on_player_button_down(players):
	$UI/MessageLabel.text = "Number of balls?"
	$UI/Buttons/Balls.get_child(0).grab_focus()
	GameManager.num_players = players
	$UI/Buttons/Players.visible = false
	$UI/Buttons/Balls.visible = true


func _on_ball_button_down(balls):
	GameManager.num_balls = balls
	$UI/Buttons/Balls.visible = false
	
	match GameManager.num_players:
		1:
			GameManager.change_scene("res://levels/1_player/World1.tscn")
		2:
			GameManager.change_scene("res://levels/2_players/World2.tscn")
		3:
			GameManager.change_scene("res://levels/3_players/World3.tscn")
		4:
			GameManager.change_scene("res://levels/4_players/World4.tscn")


func _on_return_button_down():
	GameManager.change_scene("res://main_menu/MainMenu.tscn")