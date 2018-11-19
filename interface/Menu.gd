extends Control

onready var Name = $VBoxContainer/Name/TextField
onready var PlayerIP =  $VBoxContainer/PlayerIP/TextField
onready var PlayerPort = $VBoxContainer/PlayerPort/TextField

func _on_CreateButton_pressed():
	var player_name = Name.text
	var port = PlayerPort.text.to_int()
	if player_name == "":
		return
	Network.create_server(player_name, port)
	_load_game()

func _on_JoinButton_pressed():
	var player_name = Name.text
	var port = PlayerPort.text.to_int()
	var ip = PlayerIP.text
	if player_name == "":
		return
	Network.connect_to_server(player_name, port, ip)
	_load_game()

func _load_game():
	get_tree().change_scene('res://main_menu/GameSetup.tscn')
