extends "res://characters/character.gd"

export (int) var offset = 10

var originalPos
var player = 0

func _ready():
	originalPos = position

func _physics_process(delta):
	input_direction = Vector2()
	var right
	var left
	if player == 0:
		# Use keyboard inputs
		right = int(Input.is_key_pressed(KEY_RIGHT))
		left = int(Input.is_key_pressed(KEY_LEFT))
	else:
		# Use gamepads
		var RIGHT = JOY_BUTTON_15
		var LEFT = JOY_BUTTON_14
		right = int(Input.is_joy_button_pressed(player - 1, RIGHT))
		left = int(Input.is_joy_button_pressed(player - 1, LEFT))
	input_direction.x = right - left
	input_direction = input_direction.rotated(deg2rad(rotation_degrees))
	
	# Running
	max_speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED