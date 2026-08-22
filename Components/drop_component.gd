class_name DropComponent
extends Node

@export var droppable: Control

func _ready() -> void:
	add_to_group("drop_target")
	var parent = get_parent() as Control
	if parent:
		droppable = parent
	else:
		return
