class_name DropComponent
extends Node

signal occupancy_changed(state: State)

enum State {
	UNOCCUPIED,
	OCCUPIED,
}

@export var droppable: Control

var state := State.UNOCCUPIED

func _ready() -> void:
	add_to_group("drop_target")
	var parent := get_parent() as Control
	if parent:
		droppable = parent
	else:
		# TODO: proper error handling
		return
	droppable.child_entered_tree.connect(_on_child_entered_tree)


func _on_child_entered_tree(node: Node) -> void:
	print(node.find_child("DropComponent"))
