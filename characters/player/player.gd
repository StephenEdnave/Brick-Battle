extends "res://characters/character.gd"

signal set_movement
var key_right
var key_left
var key_up
var key_down

var originalPos
var player = 0
onready var Offset = $Offset

#slave var slave_position = Vector2()
#slave var slave_movement = Vector2()
var controller_index = 0

var setting_direction

func _ready():
	._ready()
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
	
	if player == 0 or player == 1:
		if not key_right or not key_left:
			return
		right = int(Input.is_key_pressed(key_right) or Input.is_joy_button_pressed(controller_index, key_right))
		left = int(Input.is_key_pressed(key_left) or Input.is_joy_button_pressed(controller_index, key_left))
	elif player == 2 or player == 3:
		if not key_up or not key_down:
			return
		up = int(Input.is_key_pressed(key_up) or Input.is_joy_button_pressed(controller_index, key_up))
		down = int(Input.is_key_pressed(key_down) or Input.is_joy_button_pressed(controller_index, key_down))
	input_direction.x = right - left
	input_direction.y = down - up
	# Running
	max_speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED

func set_key(direction):
	setting_direction = direction
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept"):
		return
	
	if event is InputEventKey:
		match setting_direction:
			"right":
				key_right = event.scancode
			"left":
				if key_right == event.scancode:
					return
				key_left = event.scancode
			"up":
				key_up = event.scancode
			"down":
				if key_up == event.scancode:
					return
				key_down = event.scancode
		set_process_input(false)
		emit_signal("set_movement")
	elif event is InputEventJoypadButton:
		match setting_direction:
			"right":
				key_right = event.button_index
			"left":
				if key_right == event.scancode:
					return
				key_left = event.button_index
			"up":
				key_up = event.button_index
			"down":
				if key_up == event.scancode:
					return
				key_down = event.button_index
		set_process_input(false)
		emit_signal("set_movement")

#func network_move():
#	var right
#	var left
#	var up
#	var down
#	if is_network_master():
#		if player == 0 or player == 1:
#			# Use keyboard inputs
#			right = int(Input.is_key_pressed(KEY_RIGHT))
#			left = int(Input.is_key_pressed(KEY_LEFT))
#		#elif player == 1:
#		#	right = int(Input.is_key_pressed(KEY_V))
#		#	left = int(Input.is_key_pressed(KEY_C))
#		elif player == 2 or player == 3:
#			up = int(Input.is_key_pressed(KEY_UP))
#			down = int(Input.is_key_pressed(KEY_DOWN))
#		#	up = int(Input.is_key_pressed(KEY_Q))
#		#	down = int(Input.is_key_pressed(KEY_A))
#		#elif player == 3:
#		#	up = int(Input.is_key_pressed(KEY_O))
#		#	down = int(Input.is_key_pressed(KEY_L))
#		else:
#			# Use gamepads
#			var RIGHT = JOY_BUTTON_15
#			var LEFT = JOY_BUTTON_14
#			right = int(Input.is_joy_button_pressed(player - 1, RIGHT))
#			left = int(Input.is_joy_button_pressed(player - 1, LEFT))
#		input_direction.x = right - left
#		input_direction.y = down - up
#		#input_direction = input_direction.rotated(deg2rad(rotation_degrees))
#
#		rset_unreliable('slave_position', position)
#		rset('slave_movement', input_direction)
#	else:
#		position = slave_position
#		input_direction = slave_movement
#
#
#func init(nickname, start_position, is_slave):
#	pass
#	#$GUI/Nickname.text = nickname
#	#global_position = start_position
#	#if is_slave:
#	#	$Sprite.texture = load('res://player/player-alt.png')