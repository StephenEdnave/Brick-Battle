extends "res://objects/object.gd"

export (int) var amount = 1


func _ready():
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	if body.is_in_group("Player"):
		#Stats.money += amount
		queue_free()