extends KinematicBody2D

var input_direction = Vector2()
var look_direction = Vector2(1, 0)
var last_move_direction = Vector2(1, 0)

export (int) var MAX_WALK_SPEED = 200
export (int) var MAX_RUN_SPEED = 400

var speed = 0
var max_speed = 0

var velocity = Vector2()

enum STATES { IDLE, MOVE }
var state = null


func _ready():
	_change_state(STATES.IDLE)


func _change_state(new_state):
	match new_state:
		STATES.IDLE:
			$AnimationPlayer.play("idle")
		STATES.MOVE:
			$AnimationPlayer.play("walk")
	state = new_state


func _physics_process(delta):
	get_input_direction()
	update_direction()
	
	match state:
		STATES.IDLE:
			if input_direction:
				_change_state(STATES.MOVE)
				return
		STATES.MOVE:
			if not input_direction:
				_change_state(STATES.IDLE)
				return
			move(delta, input_direction)


func get_input_direction():
	pass


func update_direction():
	if not input_direction:
		return
	
	last_move_direction = input_direction
	if input_direction.x in [-1, 1]:
		look_direction.x = input_direction.x
		$Pivot.set_scale(Vector2(look_direction.x, 1))


func move(delta, direction):
	if direction:
		if speed != max_speed:
			speed = max_speed
	else:
		speed = 0
	
	velocity = direction.normalized() * speed
	move_and_slide(velocity, Vector2(), 5, 2)
	#position += velocity * delta
	var slide_count = get_slide_count()
	return get_slide_collision(slide_count - 1) if slide_count else null