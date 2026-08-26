@tool
class_name TierCategory
extends HBoxContainer

@onready var tier_name: TierName = %TierName
@onready var card_grid_panel_container: PanelContainer = %CardGridPanelContainer
@onready var card_grid: CardGrid = %CardGrid
@onready var category_settings: CategorySettings = %CategorySettings

func _ready() -> void:
	set_self()


func set_self() -> void:
	add_theme_constant_override(&"separation", 0)
