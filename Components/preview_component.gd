@tool
class_name PreviewComponent
extends Node

@export var parent_scene: PackedScene
@export var parent: Control

var preview: Control
var preview_drag_component: DragComponent
var drag_component: DragComponent

func _ready() -> void:
	parent = get_parent() as Control
	if not parent:
		return
	drag_component = parent.find_child("DragComponent")
	if not drag_component:
		return
	parent_scene = get_parent_scene()
	if not parent_scene:
		return


func _process(delta: float) -> void:
	match drag_component.drag_state:
		DragComponent.State.PICKUP:
			handle_pickup()
		DragComponent.State.DRAGGING:
			handle_dragging()
		DragComponent.State.DROPPING:
			handle_dropping()
		_:
			pass


func _on_drag_component_state_changed(new_state: DragComponent.State) -> void:
	match new_state:
		DragComponent.State.PICKUP:
			handle_pickup()
		DragComponent.State.DRAGGING:
			handle_dragging()
		DragComponent.State.DROPPING:
			handle_dropping()
		_:
			pass


func handle_pickup() -> void:
	if not parent_scene:
		return
	preview = parent_scene.instantiate()
	preview.self_modulate.a = 0.5
	get_tree().get_first_node_in_group(&"card_layer").add_child(preview)
	disable_preview_interaction()


func handle_dragging() -> void:
	var target = drag_component.find_drop_target()
	if target:
		preview.reparent(target)


func handle_dropping() -> void:
	if preview:
		preview.queue_free()
		preview = null


func disable_preview_interaction() -> void:
	preview_drag_component = preview.find_child("DragComponent")
	preview_drag_component.set_process(false)
	preview_drag_component.set_physics_process(false)
	preview_drag_component.set_process_input(false)
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE


func get_parent_scene() -> PackedScene:
	if parent_scene:
		return parent_scene
	if parent.scene_file_path.is_empty():
		return null
	return load(parent.scene_file_path) as PackedScene


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if not parent:
		warnings.push_back("Must be child of a Control Node")
	if not drag_component:
		warnings.push_back("Must have DragComponent as sibling")
	if not parent_scene:
		warnings.push_back("Parent must be a custom scene")
	return warnings
