class_name DragComponent
extends Node

enum State {
	IDLE,
	PICKUP,
	DRAGGING,
	DROPPING,
}

@export var draggable: Control = null

var drag_state := State.IDLE
var drag_offset := Vector2.ZERO

func _ready() -> void:
	var parent = get_parent() as Control
	if parent:
		draggable = parent
	else:
		# TODO: proper error handling
		return

func _process(_delta: float) -> void:
	match drag_state:
		State.IDLE:
			pass
		State.PICKUP:
			handle_pickup()
		State.DRAGGING:
			handle_dragging()
		State.DROPPING:
			handle_dropping()


func _input(event: InputEvent) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	if event.is_action_pressed(&"mouse_button_left") and has_point(mouse_pos):
		if mouse_over_type(Button):
			return
		get_viewport().set_input_as_handled()
		change_state(State.PICKUP)
	if event.is_action_released(&"mouse_button_left") and has_point(mouse_pos):
		get_viewport().set_input_as_handled()
		change_state(State.DROPPING)


func change_state(new_state: State) -> void:
	drag_state = new_state


func handle_pickup() -> void:
	drag_offset = get_offset()
	draggable.move_to_front()
	draggable.reparent(get_tree().get_first_node_in_group("card_layer"))
	change_state(State.DRAGGING)


func handle_dragging() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	draggable.global_position = mouse_pos + drag_offset


func handle_dropping() -> void:
	var target := find_drop_target()
	if not target or target.find_child("DragComponent", true, false):
		change_state(State.IDLE)
		return
	draggable.global_position = target.global_position + target.size / 2 - draggable.size / 2
	draggable.reparent(target)
	change_state(State.IDLE)


func find_drop_target() -> Control:
	var my_rect := draggable.get_global_rect()
	var best_target: Control = null
	var best_overlap: float = 0.0

	for drop_component in get_tree().get_nodes_in_group("drop_target"):
		var target := (drop_component as DropComponent).droppable
		if target == null:
			continue
		var target_rect := target.get_global_rect()
		if target_rect.intersects(my_rect):
			var overlap := my_rect.intersection(target_rect).get_area()
			if overlap > best_overlap:
				best_overlap = overlap
				best_target = target

	return best_target


func mouse_over_type(type: Variant) -> bool:
	for child in draggable.get_children():
		if child is not Button:
			continue
		var is_in_point: bool = child.get_global_rect().has_point(get_viewport().get_mouse_position())
		if is_instance_of(child, type) and is_in_point:
			return true
	return false


func get_offset() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	var parent_pos = draggable.global_position
	var offset = parent_pos - mouse_pos
	return offset


func has_point(point: Vector2) -> bool:
	return Rect2(draggable.global_position, draggable.size).has_point(point)
