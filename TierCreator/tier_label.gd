@tool
class_name TierLabel
extends Container

@onready var background_color_rect: ColorRect = %BackgroundColorRect
@onready var tier_label: Label = %TierLabel

func _ready() -> void:
	set_sizes()
	set_label_settings()
	connect_signals()
	background_color_rect.size = tier_label.size


func set_sizes() -> void:
	background_color_rect.custom_minimum_size = Vector2(Utils.min_size_x, Utils.min_size_y)
	background_color_rect.custom_maximum_size = Vector2(Utils.max_size_x, -1.0)
	tier_label.custom_minimum_size = Vector2(Utils.min_size_x, Utils.min_size_y)
	tier_label.custom_maximum_size = Vector2(Utils.max_size_x, -1.0)
	custom_minimum_size = Vector2(Utils.min_size_x, Utils.min_size_y)
	custom_maximum_size = Vector2(Utils.max_size_x, -1.0)


func set_label_settings() -> void:
	tier_label.add_theme_constant_override(&"line_spacing", 0)
	tier_label.add_theme_constant_override(&"outline_size", 4)
	tier_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tier_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tier_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART


func connect_signals() -> void:
	tier_label.resized.connect(_on_tier_label_resized)


func _on_tier_label_resized() -> void:
	background_color_rect.size = tier_label.size
