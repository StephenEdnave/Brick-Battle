extends Position2D

export (int) var index = 0

func spawn_brick():
	var new_brick = Utils.spawn_brick(index)
	new_brick.position = Vector2()
	add_child(new_brick)
	return new_brick