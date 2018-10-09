extends Control


func _ready():
	$UI/Buttons/StartButton.grab_focus()

func _on_StartButton_button_down():
	GameManager.change_scene("res://main_menu/GameSetup.tscn")

func _on_ExitButton_button_down():
	get_tree().quit()
