@tool
class_name DropNode
extends PanelContainer

func _ready() -> void:
	custom_minimum_size = Vector2(Utils.min_size_x, Utils.min_size_y)
	custom_maximum_size = Vector2(Utils.max_size_x, Utils.max_size_y)
