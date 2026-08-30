@tool
class_name TierCreator
extends Node

const TIER_CATEGORY = preload("uid://wbyer077b6mf")

@onready var card_v_box_container: VBoxContainer = %CardVBoxContainer
@onready var settings_window: SettingsWindow = %SettingsWindow
@onready var card_bench_scroll_container: ScrollContainer = %CardBenchScrollContainer
@onready var tier_list: TierList = %TierList
@onready var card_creator: CardCreator = %CardCreator


func _ready() -> void:
	set_settings_window()
	set_card_v_box_container()
	set_card_bench_scroll_container()
	set_screenshot_texture_button()
	set_save_file_dialog()
	add_tier_category()


func set_settings_window() -> void:
	settings_window.close_button.pressed.connect(close_settings_window)
	settings_window.close_texture_button.pressed.connect(close_settings_window)


func set_card_v_box_container() -> void:
	card_v_box_container.mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_card_bench_scroll_container() -> void:
	card_bench_scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	card_bench_scroll_container.custom_minimum_size = Vector2(-1.0, Utils.MIN_SIZE_Y)


func set_screenshot_texture_button() -> void:
	card_creator.screenshot_texture_button.pressed.connect(_on_screenshot_texture_button_pressed)


func set_save_file_dialog() -> void:
	card_creator.save_file_dialog.file_selected.connect(_on_save_file_selected)


func _on_screenshot_texture_button_pressed() -> void:
	card_creator.save_file_dialog.popup_centered()


func _on_save_file_selected(path: String) -> void:
	var img := await capture_screenshot(tier_list.tiers_v_box_container)
	img.save_png(path)


func add_tier_category() -> void:
	var tier_category := TIER_CATEGORY.instantiate() as TierCategory
	tier_list.tiers_v_box_container.add_child(tier_category)
	connect_tier_category_signals(tier_category)


func capture_screenshot(node: Control) -> Image:
	var sub_viewport := SubViewport.new()
	sub_viewport.size = node.size
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(sub_viewport)
	sub_viewport.add_child(node.duplicate(DUPLICATE_SIGNALS))
	await RenderingServer.frame_post_draw
	var img := sub_viewport.get_texture().get_image()
	sub_viewport.queue_free()
	return img


func connect_tier_category_signals(tier_category: TierCategory) -> void:
	tier_category.category_settings.settings_texture_button.pressed \
		.connect(
			_on_settings_texture_button_pressed \
			.bind(tier_category)
		)
	tier_category.category_settings.up_texture_button.pressed \
		.connect(
			_on_category_settings_up_texture_button_pressed \
			.bind(tier_category)
		)
	tier_category.category_settings.down_texture_button.pressed \
		.connect(
			_on_category_settings_down_texture_button_pressed \
			.bind(tier_category)
		)
	tier_category.resized \
		.connect(
			_on_tier_category_resized \
			.bind(tier_category)
		)


func close_settings_window() -> void:
	settings_window.hide()
	settings_window.tier_name_line_edit.text = ""
	settings_window.tier_name_line_edit.text_changed.disconnect(_on_tier_name_changed)
	settings_window.tier_color_line_edit.text_submitted.disconnect(_on_tier_color_text_submitted)
	settings_window.add_above_button.pressed.disconnect(_on_add_above_button_pressed)
	settings_window.add_below_button.pressed.disconnect(_on_add_below_button_pressed)
	settings_window.remove_button.pressed.disconnect(_on_remove_button_pressed)


func _on_settings_texture_button_pressed(tier_category: TierCategory) -> void:
	settings_window.show()
	settings_window.tier_name_line_edit.text = tier_category.tier_name.tier_label.text
	settings_window.tier_name_line_edit.text_changed \
		.connect(
			_on_tier_name_changed \
			.bind(tier_category)
			)
	settings_window.tier_color_line_edit.text \
		= tier_category.tier_name.background_color_rect.color.to_html(false)
	settings_window.tier_color_line_edit.text_submitted \
		.connect(_on_tier_color_text_submitted \
			.bind(tier_category)
			)
	settings_window.add_above_button.pressed \
		.connect(_on_add_above_button_pressed \
			.bind(tier_category)
			)
	settings_window.add_below_button.pressed \
		.connect(_on_add_below_button_pressed \
			.bind(tier_category)
			)
	settings_window.remove_button.pressed \
		.connect(_on_remove_button_pressed \
			.bind(tier_category)
			)


func _on_tier_name_changed(new_text: String, tier_category: TierCategory) -> void:
	tier_category.tier_name.tier_label.text = new_text


func _on_tier_color_text_submitted(new_text: String, tier_category: TierCategory) -> void:
	if not Color.html_is_valid(new_text):
		return
	var color = Color.html(new_text)
	tier_category.tier_name.background_color_rect.color = color


func _on_add_above_button_pressed(tier_category: TierCategory) -> void:
	var new_tier_category := TIER_CATEGORY.instantiate() as TierCategory
	var index: int = tier_category.get_index()
	tier_list.tiers_v_box_container.add_child(new_tier_category)
	tier_list.tiers_v_box_container.move_child(new_tier_category, index)
	connect_tier_category_signals(new_tier_category)


func _on_add_below_button_pressed(tier_category: TierCategory) -> void:
	var new_tier_category := TIER_CATEGORY.instantiate() as TierCategory
	var index: int = tier_category.get_index()
	tier_list.tiers_v_box_container.add_child(new_tier_category)
	tier_list.tiers_v_box_container.move_child(new_tier_category, index + 1)
	connect_tier_category_signals(new_tier_category)


func _on_remove_button_pressed(tier_category: TierCategory) -> void:
	if tier_list.tiers_v_box_container.get_child_count() == 1:
		push_warning("Only one category left")
		return
	tier_category.queue_free()
	close_settings_window()


func _on_category_settings_up_texture_button_pressed(tier_category: TierCategory) -> void:
	var index: int = tier_category.get_index()
	if index == 0:
		return
	tier_list.tiers_v_box_container.move_child(tier_category, index - 1)


func _on_category_settings_down_texture_button_pressed(tier_category: TierCategory) -> void:
	var index: int = tier_category.get_index()
	if index == tier_list.tiers_v_box_container.get_child_count() - 1:
		return
	tier_list.tiers_v_box_container.move_child(tier_category, index + 1)


func _on_tier_category_resized(tier_category: TierCategory) -> void:
	tier_category.tier_name.background_color_rect.size = tier_category.size
	tier_category.tier_name.tier_label.size = tier_category.size
