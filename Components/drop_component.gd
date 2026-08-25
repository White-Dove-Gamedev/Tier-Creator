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
	droppable.child_exiting_tree.connect(_on_child_exiting_tree)


func _on_child_entered_tree(node: Node) -> void:
	var drag_component := node.find_child("DragComponent")
	if not drag_component:
		return
	state = State.OCCUPIED
	occupancy_changed.emit(state)


func _on_child_exiting_tree(node: Node) -> void:
	var drag_component := node.find_child("DragComponent", true, false)
	if not drag_component:
		return
	state = State.UNOCCUPIED
	occupancy_changed.emit(state)
