class_name Utils

const MIN_SIZE_X: float = 96.0
const MIN_SIZE_Y: float = 96.0
const MAX_SIZE_X: float = 96.0
const MAX_SIZE_Y: float = 96.0

static func strip_components(node: Node, include_internal: bool = false) -> void:
	for child in node.get_children():
		if child is ComponentBase:
			child.queue_free()
		if include_internal:
			strip_components(child)
