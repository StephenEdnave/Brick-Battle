extends CanvasLayer

var _main_menu = "res://main_menu/MainMenu.tscn"

func _ready():
	for i in range($UI/Lives.get_child_count()):
		$UI/Lives.get_child(i).get_node("Label").modulate = GameManager.PlayerColors[i + 1]
	$UI/GameOverHUD.visible = false
	$UI/GameOverHUD/VBoxContainer/RestartButton.connect("button_down", get_tree(), "reload_current_scene")
	$UI/GameOverHUD/VBoxContainer/QuitButton.connect("button_down", self, "quit_to_main_menu")
	
	$UI/PauseHUD.visible = false
	$UI/PauseHUD/VBoxContainer/ResumeButton.connect("button_down", self, "pause")
	$UI/PauseHUD/VBoxContainer/RestartButton.connect("button_down", self, "restart")
	$UI/PauseHUD/VBoxContainer/QuitButton.connect("button_down", self, "quit_to_main_menu")

func _input(event):
	var PAUSE = JOY_BUTTON_11
	if event.is_action_pressed("ui_cancel"):
		pause()

func restart():
	get_tree().paused = false
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().reload_current_scene()

func pause():
	if $UI/GameOverHUD.visible:
		return
	get_tree().paused = not get_tree().paused
	$UI/PauseHUD.visible = get_tree().paused
	$UI/PauseHUD/VBoxContainer.get_node("ResumeButton").grab_focus()

func quit_to_main_menu():
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().paused = false
	get_tree().change_scene(_main_menu)