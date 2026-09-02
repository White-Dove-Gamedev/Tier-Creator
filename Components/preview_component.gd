@tool
class_name PreviewComponent
extends ComponentBase

@export var parent: Control

var preview: Control
var drag_component: DragComponent
var state: DragComponent.State
var previous_grid: GridContainer

func _ready() -> void:
	parent = get_parent() as Control
	if not parent:
		return
	drag_component = parent.find_child("DragComponent")
	if not drag_component or not get_parent_scene():
		return
	connect_signals()


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	match state:
		DragComponent.State.DRAGGING:
			handle_dragging()


func connect_signals() -> void:
	drag_component.state_changed.connect(_on_drag_component_state_changed)


func _on_drag_component_state_changed(new_state: DragComponent.State) -> void:
	state = new_state
	match new_state:
		DragComponent.State.PICKUP:
			handle_pickup()
		DragComponent.State.DROPPING:
			handle_dropping()


func handle_pickup() -> void:
	preview = parent.duplicate(DUPLICATE_USE_INSTANTIATION) as Control
	if not preview:
		return
	preview.modulate.a = 0.5
	Utils.strip_components(preview)
	get_tree().get_first_node_in_group(&"card_layer").add_child(preview)
	preview.hide()
	disable_preview_interaction()


func handle_dragging() -> void:
	var target := drag_component.find_drop_target(true) as Control
	if target:
		previous_grid = target.get_parent() as GridContainer
		var unoccupied_droppable := find_unoccupied_droppable()
		if unoccupied_droppable:
			previous_grid.move_child(unoccupied_droppable, target.get_index())
		preview.show()
		preview.reparent(target)
	else:
		if previous_grid:
			previous_grid.move_child(find_unoccupied_droppable(), previous_grid.get_child_count() - 1)
		preview.hide()
		preview.reparent(get_tree().get_first_node_in_group(&"card_layer"))


func find_unoccupied_droppable() -> Control:
	if previous_grid:
		var drop_components = previous_grid.find_children("", "DropComponent", true, false) as Array[DropComponent]
		for drop_component in drop_components:
			if not drop_component.draggable:
				return drop_component.droppable
	return null


func handle_dropping() -> void:
	if preview:
		preview.queue_free()
		preview = null


func disable_preview_interaction() -> void:
	var preview_drag_component := preview.find_child("DragComponent") as DragComponent
	preview_drag_component.set_process(false)
	preview_drag_component.set_physics_process(false)
	preview_drag_component.set_process_input(false)
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE


func get_parent_scene() -> PackedScene:
	if parent.scene_file_path.is_empty():
		return null
	return load(parent.scene_file_path) as PackedScene


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if not parent:
		warnings.push_back("Must be child of a Control Node")
	if not drag_component:
		warnings.push_back("Must have DragComponent as sibling")
	if not get_parent_scene():
		warnings.push_back("Parent must be a custom scene")
	return warnings
