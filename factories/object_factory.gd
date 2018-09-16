extends Node

export (Array) var objects = Array()

func spawn_object(index):
	if typeof(index) == TYPE_STRING:
		return get_node(index).duplicate()
	else:
		return get_node(objects[index]).duplicate()