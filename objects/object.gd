extends Area2D

var speed = 0
var velocity = Vector2()
export (int) var duration = 5


func _ready():
	velocity = 0
	initialize_timer()


func initialize_timer():
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.name = "Timer"
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)
	$Timer.start()


func _on_Timer_timeout():
	queue_free()


func _physics_process(delta):
	var acceleration = gravity * delta / 10
	speed += acceleration
	velocity = gravity_vec.normalized() * speed
	position += velocity