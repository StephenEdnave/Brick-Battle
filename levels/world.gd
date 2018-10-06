extends Node2D

var _main_menu = load("res://MainMenu.tscn")

var _player = preload("res://characters/player/Player.tscn")
var _ball = preload("res://objects/Ball.tscn")

var num_players = 4
var players = []
var lives = []

var start_countdown = 3

var balls = 0

export (Array, String) var levels = Array()
var current_level = 0

func _ready():
	#OS.set_window_fullscreen(true)
	Utils.camera = $Camera
	$StartCountdownTimer.connect("timeout", self, "_on_StartCountdownTimer_timeout")
	$GameOverTimer.connect("timeout", self, "_on_GameOverTimer_timeout")
	$BallRespawnTimer.connect("timeout", self, "_on_BallRespawnTimer_timeout")
	$NextLevelTimer.connect("timeout", self, "_on_NextLevelTimer_timeout")
	
	for i in range(num_players):
		$Goals.get_child(i).connect("goal", self, "goal")
		players.push_back(_player.instance())
		players[i].position = $StartPositions.get_child(i).position
		players[i].rotation_degrees = $StartPositions.get_child(i).rotation_degrees
		players[i].show()
		players[i].player = i
		add_child(players[i])
		lives.push_back(10)
	
	new_game()


func new_game():
	current_level = 0
	new_level()


func new_level():
	if current_level == levels.size():
		current_level = 0
	
	var new_level = load(levels[current_level]).instance()
	new_level.connect("level_win", self, "level_win")
	new_level.spawn_bricks()
	add_child(new_level)
	
	$Background/Background.modulate.r = (sin((current_level * 30) * (PI / 180) + 0) * 30 + 100) / 255
	$Background/Background.modulate.g = (sin((current_level * 30) * (PI / 180) + 2) * 30 + 80) / 255
	$Background/Background.modulate.b = (sin((current_level * 30) * (PI / 180) + 4) * 30 + 128) / 255
	
	$Interface/UI/GameOverHUD.hide()
	
	start_StartCountdownTimer()


func start_StartCountdownTimer():
	start_countdown = 3
	$Interface/UI/MessageLabel.text = str(start_countdown)
	$StartCountdownTimer.start()


func _on_StartCountdownTimer_timeout():
	start_countdown -= 1
	$Interface/UI/MessageLabel.text = str(start_countdown)
	
	if start_countdown <= 0:
		for i in range(num_players - balls):
			spawn_ball(i)
		$StartCountdownTimer.stop()
		$Interface/UI/MessageLabel.hide()


func _on_BallRespawnTimer_timeout():
	for i in range(num_players - balls):
		var rnd_spawn = randi() % num_players
		spawn_ball(rnd_spawn)


func spawn_ball(index):
	# Spawn ball
	var ball = _ball.instance()
	ball.position = $BallSpawnPositions.get_child(index).position
	ball.linear_velocity = -ball.position # Assumes the game is centered around Vector2(0, 0)
	add_child(ball)
	balls += 1


func goal(player):
	balls -= 1
	lives[player] -= 1
	$Interface/UI/Lives.get_child(player).text = "p%s lives\n%s" % [player + 1, lives[player]]
	$BallRespawnTimer.start()


func game_over():
	$Interface/UI/MessageLabel.text = "Game over!"
	$Interface/UI/MessageLabel.show()
	$Interface/UI/GameOverHUD.show()


func quit_to_main_menu():
	$GameOverTimer.start()


func _on_GameOverTimer_timeout():
	var main_menu = _main_menu.instance()
	get_parent().add_child(main_menu)
	queue_free()


func pause():
	get_tree().paused = true
	$Interface/UI/MessageLabel.text = "Paused"
	$Interface/UI/MessageLabel.show()


func unpause():
	get_tree().paused = false
	$Interface/UI/MessageLabel.hide()


func level_win():
	$Interface/UI/MessageLabel.text = "Spawning new bricks"
	$Interface/UI/MessageLabel.show()
	$NextLevelTimer.start()


func _on_NextLevelTimer_timeout():
	current_level = current_level + 1
	new_level()