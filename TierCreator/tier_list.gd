@tool
class_name TierList
extends Control

@onready var tier_list_scroll_container: ScrollContainer = %TierListScrollContainer
@onready var tiers_v_box_container: VBoxContainer = %TiersVBoxContainer

func _ready() -> void:
	set_self()
	set_tier_list_scroll_container()
	set_tiers_v_box_container()


func set_self() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	tiers_v_box_container.add_theme_constant_override(&"separation", 0)


func set_tier_list_scroll_container() -> void:
	#tier_list_scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	pass


func set_tiers_v_box_container() -> void:
	tiers_v_box_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
