@tool
class_name TierList
extends Control

const TIER_CATEGORY = preload("uid://wbyer077b6mf")

@onready var tiers_v_box_container: VBoxContainer = %TiersVBoxContainer
@onready var settings_window: SettingsWindow = %SettingsWindow

func _ready() -> void:
	set_self()
	set_settings_window()
	add_tier_category()


func set_self() -> void:
	tiers_v_box_container.add_theme_constant_override(&"separation", 0)


func set_settings_window() -> void:
	settings_window.hide()


func add_tier_category() -> void:
	var tier_category := TIER_CATEGORY.instantiate() as TierCategory
	tiers_v_box_container.add_child(tier_category)
	var category_settings := tier_category.category_settings.settings_texture_button
	category_settings.pressed.connect(_on_settings_texture_button_pressed.bind(tier_category))


func _on_settings_texture_button_pressed(tier_category: TierCategory) -> void:
	settings_window.show()
