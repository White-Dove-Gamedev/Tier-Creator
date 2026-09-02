@tool
class_name TierCategory
extends HBoxContainer

@onready var tier_name: TierName = %TierName
@onready var card_grid: CardGrid = %CardGrid
@onready var category_settings: CategorySettings = %CategorySettings

func _ready() -> void:
	set_self()
	set_card_grid()


func set_self() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_TOP_WIDE)
	add_theme_constant_override(&"separation", 0)


func set_card_grid() -> void:
	card_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var viewport_width = get_viewport_rect().size.x
	var card_width = viewport_width - Utils.MIN_SIZE_X * 2
	var card_amount = floorf(card_width / Utils.MIN_SIZE_X)
	card_grid.custom_minimum_size = Vector2(card_amount * Utils.MIN_SIZE_X, -1.0)
	card_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
