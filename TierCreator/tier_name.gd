@tool
class_name TierName
extends PanelContainer

@onready var background_color_rect: ColorRect = %BackgroundColorRect
@onready var tier_label: Label = %TierLabel

func _ready() -> void:
	set_self()
	set_background_color_rect()
	set_label()


func set_self() -> void:
	custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	custom_maximum_size = Vector2(Utils.MAX_SIZE_X, -1.0)


func set_background_color_rect() -> void:
	background_color_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	background_color_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	background_color_rect.color = Color.html("ffe37a")


func set_label() -> void:
	tier_label.custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	tier_label.custom_maximum_size = Vector2(Utils.MAX_SIZE_X, -1.0)
	tier_label.add_theme_constant_override(&"line_spacing", 0)
	tier_label.add_theme_constant_override(&"outline_size", 4)
	tier_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tier_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tier_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tier_label.text = "New Tier"
