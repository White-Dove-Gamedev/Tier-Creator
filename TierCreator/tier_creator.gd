@tool
class_name TierCreator
extends Node

const CARD = preload("uid://cpyj3ex8t8ttf")
const TIER_CATEGORY = preload("uid://wbyer077b6mf")

@onready var card_creator: CardCreator = %CardCreator
@onready var card_bench: CardBench = %CardBench
@onready var card_bench_scroll_container: ScrollContainer = %CardBenchScrollContainer
@onready var card_v_box_container: VBoxContainer = %CardVBoxContainer
@onready var export_file_dialog: FileDialog = %ExportFileDialog
@onready var import_file_dialog: FileDialog = %ImportFileDialog
@onready var settings_window: SettingsWindow = %SettingsWindow
@onready var tier_list: TierList = %TierList


func _ready() -> void:
	set_card_bench_scroll_container()
	set_card_creator()
	set_card_v_box_container()
	set_export_file_dialog()
	set_import_file_dialog()
	set_save_file_dialog()
	set_settings_window()
	set_screenshot_texture_button()

	add_tier_category()


func set_card_v_box_container() -> void:
	card_v_box_container.mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_card_bench_scroll_container() -> void:
	card_bench_scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	card_bench_scroll_container.custom_minimum_size = Vector2(-1.0, Utils.MIN_SIZE_Y)


func set_save_file_dialog() -> void:
	card_creator.save_file_dialog.file_selected.connect(_on_save_file_selected)


func set_card_creator() -> void:
	card_creator.export_texture_button.pressed.connect(_on_export_texture_button_pressed)
	card_creator.import_texture_button.pressed.connect(_on_import_texture_button_pressed)


func add_tier_category() -> void:
	var tier_category := TIER_CATEGORY.instantiate() as TierCategory
	tier_list.tiers_v_box_container.add_child(tier_category)
	connect_tier_category_signals(tier_category)


func _on_tier_category_resized(tier_category: TierCategory) -> void:
	tier_category.tier_name.background_color_rect.size = tier_category.size
	tier_category.tier_name.tier_label.size = tier_category.size

#region Screenshots
func set_screenshot_texture_button() -> void:
	card_creator.screenshot_texture_button.pressed.connect(_on_screenshot_texture_button_pressed)


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


func _on_screenshot_texture_button_pressed() -> void:
	card_creator.save_file_dialog.popup_centered()


func _on_save_file_selected(path: String) -> void:
	var img := await capture_screenshot(tier_list.tiers_v_box_container)
	img.save_png(path)
#endregion Screenshots

#region Save Management
func set_export_file_dialog() -> void:
	export_file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	export_file_dialog.use_native_dialog = true
	export_file_dialog.mode = Window.MODE_WINDOWED
	export_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	export_file_dialog.filters = ["*.tres"]
	export_file_dialog.title = "Export a TierList"
	export_file_dialog.file_selected.connect(_on_export_file_selected)


func set_import_file_dialog() -> void:
	import_file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	import_file_dialog.use_native_dialog = true
	import_file_dialog.mode = Window.MODE_WINDOWED
	import_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	import_file_dialog.filters = ["*.tres"]
	import_file_dialog.title = "Import a TierList"
	import_file_dialog.file_selected.connect(_on_import_file_selected)


func _on_export_file_selected(path: String) -> void:
	export_save_data(path)


func _on_import_file_selected(path: String) -> void:
	import_save_data(path)


func _on_export_texture_button_pressed() -> void:
	export_file_dialog.popup_centered()


func _on_import_texture_button_pressed() -> void:
	import_file_dialog.popup_centered()


func build_tier_list_save_data() -> TierListData:
	var save_data := TierListData.new()
	for tier_category in tier_list.tiers_v_box_container.get_children() as Array[TierCategory]:
		var tier_category_data := TierCategoryData.new()
		tier_category_data.name = tier_category.tier_name.tier_label.text
		tier_category_data.color = tier_category.tier_name.background_color_rect.color
		for card in tier_category.card_grid.get_cards() as Array[Card]:
			var card_data = CardData.new()
			card_data.name = card.card_label.text
			card_data.texture = card.card_texture_rect.texture
			tier_category_data.cards.append(card_data)
		save_data.categories.append(tier_category_data)
	return save_data


func build_card_bench_save_data() -> CardBenchData:
	var save_data := CardBenchData.new()
	for card in card_bench.get_cards() as Array[Card]:
		var card_data := CardData.new()
		card_data.name = card.card_label.text
		card_data.texture = card.card_texture_rect.texture
		save_data.cards.append(card_data)
	return save_data


func export_save_data(path: String) -> void:
	var save_data := TierCreatorData.new()
	save_data.tier_list = build_tier_list_save_data()
	save_data.card_bench = build_card_bench_save_data()
	ResourceSaver.save(save_data, path)


func import_save_data(path: String) -> void:
	clear_scene()
	var save_data := load(path) as TierCreatorData
	if not save_data:
		return
	for tier_category_data in save_data.tier_list.categories:
		var tier_category := TIER_CATEGORY.instantiate() as TierCategory
		tier_list.tiers_v_box_container.add_child(tier_category)
		connect_tier_category_signals(tier_category)
		tier_category.tier_name.tier_label.text = tier_category_data.name
		tier_category.tier_name.background_color_rect.color = tier_category_data.color
		for card_data in tier_category_data.cards:
			var card := CARD.instantiate() as Card
			var droppable := tier_category.card_grid.get_child(tier_category.card_grid.get_child_count() - 1) as DropNode
			droppable.add_child(card)
			card.card_label.text = card_data.name
			card.card_texture_rect.texture = card_data.texture
	for card_bench_data in save_data.card_bench.cards:
		var card := CARD.instantiate() as Card
		var droppable := card_bench.get_child(card_bench.get_child_count() - 1) as DropNode
		droppable.add_child(card)
		card.card_label.text = card_bench_data.name
		card.card_texture_rect.texture = card_bench_data.texture


func clear_scene() -> void:
	for child in tier_list.tiers_v_box_container.get_children():
		child.queue_free()
	card_bench.clear_bench()
#endregion Save Management

#region Tierlist Settings
func set_settings_window() -> void:
	settings_window.close_button.pressed.connect(close_settings_window)
	settings_window.close_texture_button.pressed.connect(close_settings_window)


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
#endregion Tierlist Settings
