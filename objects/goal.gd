extends Area2D

signal goal

export(int) var player = 0

func _ready():
	connect("body_entered", self, "_on_body_entered")


# Only object that should be entering is the ball
func _on_body_entered(object):
	object.queue_free()
	emit_signal("goal", player)