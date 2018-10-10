extends StaticBody2D

signal brick_died

export (int) var health = 1
export (int) var next_brick = -1


func _ready():
	$AnimationPlayer.play("SETUP")


func damage(value):
	health -= value
	if health <= 0:
		die()


func die():
	# Spawn a new brick if index will let it
	var new_brick = null
	if next_brick != -1:
		new_brick = Utils.spawn_brick(next_brick)
		new_brick.position = position
		get_parent().add_child(new_brick)
	else:
		# If no new brick, RNG spawn an item
		randomize()
		var item_roll = randf()
		var new_object = null
		
		if item_roll <= 0.2:
			#new_object = Utils.spawn_object("Ball")
			pass
		elif item_roll > 0.2 and item_roll <= 1.0:
			pass
#			new_object = Utils.spawn_object("MoneyDrop")
		if new_object != null:
			new_object.position = position
			get_parent().add_child(new_object)
	
	emit_signal("brick_died", self, new_brick)
	queue_free()