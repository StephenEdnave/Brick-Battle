extends Node2D

signal level_win

var brick_max = 0
var brick_count = 0


func spawn_bricks():
	brick_count = 0
	brick_max = 0
	for brick in $BrickPositions.get_children():
		# Get rid of currently existing bricks
		for spawned_brick in brick.get_children():
			spawned_brick.queue_free()
		var new_brick = brick.spawn_brick()
		new_brick.connect("brick_died", self, "brick_died")
		brick_count += 1
		brick_max += 1


func brick_died(new_brick):
	if new_brick != null:
		Utils.screen_freeze(0.004)
		Utils.camera.shake(0.2, 12, 4)
		new_brick.connect("brick_died", self, "brick_died")
	else: # Brick died
		Utils.screen_freeze(0.02)
		Utils.camera.shake(0.4, 12, 8)
		
		brick_count -= 1
		$BrickDestroySound.play()
		if brick_count <= 0:
			emit_signal("level_win")
			queue_free()