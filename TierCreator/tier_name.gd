@tool
class_name TierName
extends Container

@onready var background_color_rect: ColorRect = %BackgroundColorRect
@onready var tier_label: Label = %TierLabel

func _ready() -> void:
	set_sizes()
	set_label_settings()
	connect_signals()
	background_color_rect.size = tier_label.size


func set_sizes() -> void:
	background_color_rect.custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	background_color_rect.custom_maximum_size = Vector2(Utils.MAX_SIZE_X, -1.0)
	tier_label.custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	tier_label.custom_maximum_size = Vector2(Utils.MAX_SIZE_X, -1.0)
	custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	custom_maximum_size = Vector2(Utils.MAX_SIZE_X, -1.0)


func set_label_settings() -> void:
	tier_label.add_theme_constant_override(&"line_spacing", 0)
	tier_label.add_theme_constant_override(&"outline_size", 4)
	tier_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tier_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tier_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func connect_signals() -> void:
	resized.connect(_on_resized.bind(self))
	tier_label.resized.connect(_on_resized.bind(tier_label))


func _on_resized(node: Control) -> void:
	if node == tier_label:
		background_color_rect.size = node.size
	tier_label.size = node.size
