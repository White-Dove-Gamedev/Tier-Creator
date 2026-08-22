class_name DragComponent
extends Node

enum State {
	IDLE,
	DRAGGING,
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


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"mouse_button_left"):
		drag_offset = get_offset()
		change_state(State.DRAGGING)
	if event.is_action_released(&"mouse_button_left"):
		change_state(State.IDLE)


func change_state(new_state: State) -> void:
	drag_state = new_state


func handle_dragging() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	draggable.position = mouse_pos + drag_offset


func get_offset() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	var parent_pos = draggable.position
	var offset = parent_pos - mouse_pos
	return offset
