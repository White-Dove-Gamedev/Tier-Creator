@tool
class_name DropNode
extends PanelContainer

func _ready() -> void:
	custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	custom_maximum_size = Vector2(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y)
