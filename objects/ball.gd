extends RigidBody2D

signal ball_died

export (int) var acceleration = 50
onready var _collision_particle = preload("res://objects/CollisionParticle.tscn")

const MAX_SPEED = 1337

func _ready():
	pass


func _on_Ball_body_entered( body ):
	var new_speed = _accelerate()
	
	if new_speed < MAX_SPEED:
		$Particles2D.amount += 1
	
	if body.is_in_group("Bricks"):
		damage_brick(body)
		linear_velocity = linear_velocity.normalized() * new_speed
	
	if body.is_in_group("Player"):
		Utils.screen_freeze(0.02)
		Utils.camera.shake(0.06, 2, 10)
		if (body.offset > 0 and global_position.x <= body.global_position.x) or (body.offset < 0 and global_position.x >= body.global_position.x):
			var direction = global_position - Vector2(body.global_position.x + body.offset, body.global_position.y)
			linear_velocity = direction.normalized() * new_speed
	
	$Particles2D.rotation_degrees = rad2deg(linear_velocity.angle())
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