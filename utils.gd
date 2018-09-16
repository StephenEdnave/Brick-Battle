extends Node

onready var brick_factory = preload("res://factories/BrickFactory.tscn").instance()
onready var object_factory = preload("res://factories/ObjectFactory.tscn").instance()
var camera
var screen_freeze_timer
var world

export (Array) var music = Array()


func _ready():
	initialize_screen_freeze_timer()
	for stream in $Music.get_children():
		stream.connect("finished", self, "_on_Music_finished")
		#print(stream.name)
	_on_Music_finished()


func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused == true:
			get_node("/root/World").pause()
		else:
			get_node("/root/World").unpause()


func initialize_screen_freeze_timer():
	screen_freeze_timer = Timer.new()
	screen_freeze_timer.one_shot = true
	screen_freeze_timer.connect("timeout", self, "_on_screen_freeze_timeout")
	screen_freeze_timer.pause_mode = PAUSE_MODE_PROCESS
	add_child(screen_freeze_timer)


func _on_screen_freeze_timeout():
	get_tree().paused = false


func spawn_brick(index):
	return brick_factory.spawn_object(index)


func spawn_object(index):
	return object_factory.spawn_object(index)


func screen_freeze(duration):
	screen_freeze_timer.wait_time = duration
	screen_freeze_timer.start()
	get_tree().paused = true


func _on_Music_finished():
	randomize()
	var random = randi() % get_child_count()
	$Music.get_child(random).play()
