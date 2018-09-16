extends "res://objects/object.gd"


func _ready():
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	if body.is_in_group("Player"):
		Utils.set_lives(Utils.lives + 1)
		queue_free()