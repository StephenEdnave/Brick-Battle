extends "res://characters/character.gd"

var originalPos
var player = 0
onready var Offset = $Offset

func _ready():
	originalPos = position

func _process(delta):
	if player == 0 or player == 1: # Move horizontally, clamp vertically
		position.y = originalPos.y
	else:
		position.x = originalPos.x


func get_input_direction():
	input_direction = Vector2()
	var right = 0
	var left = 0
	var up = 0
	var down = 0
	if player == 0:
		# Use keyboard inputs
		right = int(Input.is_key_pressed(KEY_RIGHT))
		left = int(Input.is_key_pressed(KEY_LEFT))
	elif player == 1:
		right = int(Input.is_key_pressed(KEY_RIGHT))
		left = int(Input.is_key_pressed(KEY_LEFT))
	elif player == 2:
		up = int(Input.is_key_pressed(KEY_UP))
		down = int(Input.is_key_pressed(KEY_DOWN))
	elif player == 3:
		up = int(Input.is_key_pressed(KEY_UP))
		down = int(Input.is_key_pressed(KEY_DOWN))
	else:
		# Use gamepads
		var RIGHT = JOY_BUTTON_15
		var LEFT = JOY_BUTTON_14
		right = int(Input.is_joy_button_pressed(player - 1, RIGHT))
		left = int(Input.is_joy_button_pressed(player - 1, LEFT))
	input_direction.x = right - left
	input_direction.y = down - up
	#input_direction = input_direction.rotated(deg2rad(rotation_degrees))
	
	# Running
	max_speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED