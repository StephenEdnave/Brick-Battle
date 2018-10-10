extends RigidBody2D

signal ball_died

var direction = Vector2()
var speed = 400
export (int) var acceleration = 50
onready var _collision_particle = preload("res://objects/CollisionParticle.tscn")

const MAX_SPEED = 800
export (int) var trail_length = 30

onready var MaxSpeedParticles = $MaxSpeedParticles

func _ready():
	MaxSpeedParticles.emitting = false
	set_physics_process(false)
	$AnimationPlayer.play("enter")


func _physics_process(delta):
	direction = linear_velocity.normalized()
	rotation_degrees = rad2deg(linear_velocity.angle())
	$Pivot/Trail.global_position = Vector2()
	$Pivot/Trail.global_rotation = 0
	var point = global_position
	$Pivot/Trail.add_point(point)
	while $Pivot/Trail.get_point_count() > trail_length:
		$Pivot/Trail.remove_point(0)


func _on_Ball_body_entered( body ):
	var new_direction = Vector2()
	
	if body.is_in_group("Bricks"):
		damage_brick(body)
		if speed >= MAX_SPEED:
			if body.next_brick == -1:
				new_direction = direction
	
	if body.is_in_group("Player"):
		Utils.screen_freeze(0.008)
		Utils.camera.shake(0.4, 24, 4)
		new_direction = (global_position - body.Offset.global_position).normalized()
		# Spawn collision particle
		var collision_particle = _collision_particle.instance()
		collision_particle.rotation_degrees = rad2deg(linear_velocity.angle() + PI/4)
		collision_particle.position = position
		collision_particle.restart()
		get_parent().add_child(collision_particle)
	
	speed = _accelerate()
	if speed >= MAX_SPEED:
		MaxSpeedParticles.emitting = true
	
	# Linear velocity is set like this to prevent balls from losing speed
	direction = new_direction
	if direction:
		linear_velocity = direction
	linear_velocity = linear_velocity.normalized() * speed
	
	$Pivot/Trail.global_position = Vector2()
	$Pivot/Trail.global_rotation = 0
	
	$Sound.play()


func _accelerate():
	var new_acceleration = acceleration
	if speed >= MAX_SPEED:
		new_acceleration *= MAX_SPEED / float(pow(speed, 1.4))
		print(new_acceleration)
	var new_speed = speed + new_acceleration
	return new_speed


func damage_brick(brick):
	brick.damage(1)
	
	# Spawn collision particle
	var collision_particle = _collision_particle.instance()
	collision_particle.rotation_degrees = rad2deg(linear_velocity.angle() + PI/4)
	collision_particle.position = position
	collision_particle.restart()
	get_parent().add_child(collision_particle)
	if brick.next_brick == -1:
		collision_particle.scale = Vector2(6, 6)


func goal():
	Utils.screen_freeze(0.05)
	Utils.camera.shake(0.8, 42, 24)
	MaxSpeedParticles.emitting = false
	$ExplodeParticles.emitting = true
	$CollisionShape2D.disabled = true
	$Pivot.visible = false
	$GoalSFX.play()
	$Timer.wait_time = $ExplodeParticles.lifetime
	$Timer.start()
	yield($Timer, "timeout")
	queue_free()


func _on_animation_finished(anim_name):
	if anim_name == "enter":
		linear_velocity = direction * speed
		set_physics_process(true)