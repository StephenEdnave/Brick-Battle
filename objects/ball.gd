extends RigidBody2D

signal ball_died

export (int) var acceleration = 50
onready var _collision_particle = preload("res://objects/CollisionParticle.tscn")

const MAX_SPEED = 1337
export (int) var trail_length = 30

func _ready():
	pass


func _physics_process(delta):
	$Pivot/Trail.global_position = Vector2()
	$Pivot/Trail.global_rotation = 0
	var point = global_position
	$Pivot/Trail.add_point(point)
	while $Pivot/Trail.get_point_count() > trail_length:
		$Pivot/Trail.remove_point(0)


func _on_Ball_body_entered( body ):
	var new_speed = _accelerate()
	
	if body.is_in_group("Bricks"):
		damage_brick(body)
		linear_velocity = linear_velocity.normalized() * new_speed
	
	if body.is_in_group("Player"):
		Utils.screen_freeze(0.008)
		Utils.camera.shake(0.4, 24, 4)
		var direction = global_position - body.Offset.global_position
		linear_velocity = direction.normalized() * new_speed
	
	$Sound.play()


func _accelerate():
	var speed = linear_velocity.length()
	var new_speed = min(speed + acceleration, MAX_SPEED)
	return new_speed


func damage_brick(body):
	body.damage(1)
	
	var speed = linear_velocity.length()
	
	var direction = position - body.global_position
	var velocity = direction.normalized() * min(speed + acceleration, MAX_SPEED)
	
	# Spawn collision particle
	var collision_particle = _collision_particle.instance()
	collision_particle.rotation_degrees = rad2deg(linear_velocity.angle() + PI/4)
	collision_particle.position = position
	collision_particle.restart()
	get_parent().add_child(collision_particle)
	if body.next_brick == -1:
		collision_particle.scale = Vector2(6, 6)


func goal():
	Utils.screen_freeze(0.05)
	Utils.camera.shake(0.8, 42, 24)
	$ExplodeParticles.emitting = true
	$CollisionShape2D.disabled = true
	$Pivot.visible = false
	$GoalSFX.play()
	$Timer.wait_time = $ExplodeParticles.lifetime
	$Timer.start()
	yield($Timer, "timeout")
	queue_free()