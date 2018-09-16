extends KinematicBody2D

var input_direction = Vector2()
var look_direction = Vector2(1, 0)
var last_move_direction = Vector2(1, 0)

export (int) var MAX_WALK_SPEED = 450
export (int) var MAX_RUN_SPEED = 700

var speed = 0
var max_speed = 0

var velocity = Vector2()

enum STATES { IDLE, MOVE }
var state = null


func _ready():
	_change_state(IDLE)


func _change_state(new_state):
	match new_state:
		IDLE:
			$AnimationPlayer.play("idle")
		MOVE:
			$AnimationPlayer.play("walk")
	state = new_state


func _physics_process(delta):
	update_direction()
	
	match state:
		IDLE:
			if input_direction:
				_change_state(MOVE)
		MOVE:
			if not input_direction:
				_change_state(IDLE)
			move(delta)


func update_direction():
	if not input_direction:
		return
	
	last_move_direction = input_direction
	if input_direction.x in [-1, 1]:
		look_direction.x = input_direction.x
		$Pivot.set_scale(Vector2(look_direction.x, 1))


func move(delta):
	if input_direction:
		if speed != max_speed:
			speed = max_speed
	else:
		speed = 0
	
	velocity = input_direction.normalized() * speed
	position += velocity * delta
	#position.y = clamp(position.y, -get_viewport_rect().size.y + 1000, get_viewport_rect().size.y - 150)
	#move_and_slide(velocity, Vector2(), 5, 2)
	
	var slide_count = get_slide_count()
	return get_slide_collision(slide_count - 1) if slide_count else null