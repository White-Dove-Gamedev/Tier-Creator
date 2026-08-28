@tool
class_name DragComponent
extends Node

signal state_changed(new_state: State)

enum State {
	IDLE,
	DEADZONE,
	PICKUP,
	DRAGGING,
	DROPPING,
}

@export_range(0.0, 1.0, 0.001) var overlap_threshold: float = 0.25
@export var draggable: Control = null
@export var target_name: StringName = &"drop_target"
@export var deadzone: float = 10.0

var drag_state := State.IDLE
var drag_offset := Vector2.ZERO
var old_position := Vector2.ZERO
var current_position := Vector2.ZERO

func _ready() -> void:
	var parent = get_parent() as Control
	if parent:
		draggable = parent
	else:
		# TODO: proper error handling
		return
	current_position = draggable.global_position
	old_position = draggable.global_position

func _process(_delta: float) -> void:
	match drag_state:
		State.IDLE:
			pass
		State.DEADZONE:
			handle_deadzone()
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
		drag_offset = get_offset()
		old_position = mouse_pos + drag_offset
		change_state(State.DEADZONE)
	if event.is_action_released(&"mouse_button_left") and (drag_state == State.DRAGGING or drag_state == State.DEADZONE):
		if mouse_over_type(Button) and not drag_state == State.DEADZONE:
			return
		get_viewport().set_input_as_handled()
		change_state(State.DROPPING)


func change_state(new_state: State) -> void:
	drag_state = new_state
	state_changed.emit(new_state)


func handle_deadzone() -> void:
	current_position = get_viewport().get_mouse_position() + drag_offset
	if current_position.distance_to(old_position) < deadzone:
		return
	change_state(State.PICKUP)


func handle_pickup() -> void:
	draggable.move_to_front()
	draggable.reparent(get_tree().get_first_node_in_group(&"card_layer"))
	change_state(State.DRAGGING)


func handle_dragging() -> void:
	draggable.global_position = get_viewport().get_mouse_position() + drag_offset


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

	for drop_component in get_tree().get_nodes_in_group(target_name) as Array[DropComponent]:
		var target := drop_component.droppable
		if target == null or drop_component.state == drop_component.State.OCCUPIED:
			continue
		var target_rect := target.get_global_rect()
		if target_rect.intersects(my_rect) and meets_overlap_threshold(my_rect, target_rect):
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


func meets_overlap_threshold(drag_rect: Rect2, drop_rect: Rect2) -> bool:
	var smaller_area := minf(drag_rect.get_area(), drop_rect.get_area())
	var overlap_area := drag_rect.intersection(drop_rect).get_area()
	return overlap_area > smaller_area * overlap_threshold
