@tool
class_name TierCategory
extends HBoxContainer

@onready var tier_name: TierName = %TierName
@onready var card_grid: CardGrid = %CardGrid
@onready var category_settings: CategorySettings = %CategorySettings

func _ready() -> void:
	set_self()
	set_card_grid()
	connect_signals()


func set_self() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_TOP_LEFT)
	add_theme_constant_override(&"separation", 0)


func set_card_grid() -> void:
	card_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_grid.custom_minimum_size = Vector2(Utils.MIN_SIZE_X * 10, -1.0)
	card_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL


func connect_signals() -> void:
	tier_name.resized.connect(_on_tier_name_resized)


func _on_tier_name_resized() -> void:
	size = tier_name.size
