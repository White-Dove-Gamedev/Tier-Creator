@tool
class_name CardBench
extends GridContainer

const DROP_NODE = preload("uid://g5fcgt0gasfi")

func _ready() -> void:
	set_self()
	add_drop_node()


func add_drop_node() -> void:
	var drop_node := DROP_NODE.instantiate() as DropNode
	add_child(drop_node)
	drop_node.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var drop_component := drop_node.find_child("DropComponent", true, false) as DropComponent
	if drop_component:
		drop_component.occupancy_changed.connect(
			_on_drop_component_occupancy_changed.bind(drop_node)
		)


func _on_drop_component_occupancy_changed(state: DropComponent.State, drop_node: DropNode) -> void:
	if state == DropComponent.State.OCCUPIED:
		add_drop_node()
	elif state == DropComponent.State.UNOCCUPIED:
		drop_node.queue_free()


func set_self() -> void:
	add_to_group(&"card_bench")
	columns = 12
