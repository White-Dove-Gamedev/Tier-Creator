class_name DragComponent
extends Node

enum State {
	IDLE,
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
		return

func _process(delta: float) -> void:
	match drag_state:
		State.IDLE:
			pass
		State.DRAGGING:
			handle_dragging()
		State.DROPPING:
			handle_dropping()


func _input(event: InputEvent) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	if event.is_action_pressed(&"mouse_button_left") and has_point(mouse_pos):
		drag_offset = get_offset()
		change_state(State.DRAGGING)
	if event.is_action_released(&"mouse_button_left"):
		change_state(State.DROPPING)


func change_state(new_state: State) -> void:
	drag_state = new_state


func handle_dragging() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	draggable.position = mouse_pos + drag_offset


func handle_dropping() -> void:
	var target = find_drop_target()
	if target:
		draggable.position = target.position + target.size / 2 - draggable.size / 2
	change_state(State.IDLE)

func get_offset() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	var parent_pos = draggable.position
	var offset = parent_pos - mouse_pos
	return offset


func has_point(point: Vector2) -> bool:
	return Rect2(draggable.position, draggable.size).has_point(point)


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
