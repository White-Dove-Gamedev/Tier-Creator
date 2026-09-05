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
@onready var upload_file_dialog: FileDialog = %UploadFileDialog
@onready var category_settings_window: CategorySettingsWindow = %CategorySettingsWindow
@onready var card_settings_window: CardSettingsWindow = %CardSettingsWindow
@onready var tier_list: TierList = %TierList


func _ready() -> void:
	set_card_bench_scroll_container()
	set_card_creator()
	set_card_v_box_container()
	set_export_file_dialog()
	set_import_file_dialog()
	set_upload_file_dialog()
	set_save_file_dialog()
	set_category_settings_window()
	set_screenshot_texture_button()
	set_card_settings_window()

	set_default_tier_list()


func set_default_tier_list() -> void:
	var s_tier_category := TIER_CATEGORY.instantiate() as TierCategory
	tier_list.tiers_v_box_container.add_child(s_tier_category)
	s_tier_category.tier_name.tier_label.text = "S"
	s_tier_category.tier_name.background_color_rect.color = Color.html("ff3a40")
	connect_tier_category_signals(s_tier_category)
	var a_tier_category := TIER_CATEGORY.instantiate() as TierCategory
	tier_list.tiers_v_box_container.add_child(a_tier_category)
	a_tier_category.tier_name.tier_label.text = "A"
	a_tier_category.tier_name.background_color_rect.color = Color.html("ffa34d")
	connect_tier_category_signals(a_tier_category)
	var b_tier_category := TIER_CATEGORY.instantiate() as TierCategory
	tier_list.tiers_v_box_container.add_child(b_tier_category)
	b_tier_category.tier_name.tier_label.text = "B"
	b_tier_category.tier_name.background_color_rect.color = Color.html("ffd94d")
	connect_tier_category_signals(b_tier_category)
	var c_tier_category := TIER_CATEGORY.instantiate() as TierCategory
	tier_list.tiers_v_box_container.add_child(c_tier_category)
	c_tier_category.tier_name.tier_label.text = "C"
	c_tier_category.tier_name.background_color_rect.color = Color.html("aaeb4d")
	connect_tier_category_signals(c_tier_category)
	var d_tier_category := TIER_CATEGORY.instantiate() as TierCategory
	tier_list.tiers_v_box_container.add_child(d_tier_category)
	d_tier_category.tier_name.tier_label.text = "D"
	d_tier_category.tier_name.background_color_rect.color = Color.html("59e44a")
	connect_tier_category_signals(d_tier_category)


func set_card_v_box_container() -> void:
	card_v_box_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_v_box_container.add_theme_constant_override(&"separation", 0)


func set_card_bench_scroll_container() -> void:
	card_bench_scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	card_bench_scroll_container.custom_minimum_size = Vector2(-1.0, Utils.MIN_SIZE_Y * 2.5)


func set_save_file_dialog() -> void:
	card_creator.save_file_dialog.file_selected.connect(_on_save_file_selected)


func set_card_creator() -> void:
	card_creator.export_texture_button.pressed.connect(_on_export_texture_button_pressed)
	card_creator.import_texture_button.pressed.connect(_on_import_texture_button_pressed)
	card_creator.card_created.connect(_on_card_creator_card_created)


func add_tier_category() -> void:
	var tier_category := TIER_CATEGORY.instantiate() as TierCategory
	tier_list.tiers_v_box_container.add_child(tier_category)
	connect_tier_category_signals(tier_category)


#region Screenshots
func set_screenshot_texture_button() -> void:
	card_creator.screenshot_texture_button.pressed.connect(_on_screenshot_texture_button_pressed)


func capture_screenshot(node: Control) -> Image:
	var sub_viewport := SubViewport.new()
	sub_viewport.size = node.size - Vector2(Utils.MIN_SIZE_X, 0.0)
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
			set_card_texture_bytes(card_data, card.card_texture_rect.texture.get_image())
			tier_category_data.cards.append(card_data)
		save_data.categories.append(tier_category_data)
	return save_data


func build_card_bench_save_data() -> CardBenchData:
	var save_data := CardBenchData.new()
	for card in card_bench.get_cards() as Array[Card]:
		var card_data := CardData.new()
		card_data.name = card.card_label.text
		if card.card_texture_rect.texture:
			set_card_texture_bytes(card_data, card.card_texture_rect.texture.get_image())
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
			card.card_texture_rect.texture = get_card_texture(card_data)
			connect_card_signals(card)
	for card_bench_data in save_data.card_bench.cards:
		var card := CARD.instantiate() as Card
		var droppable := card_bench.get_child(card_bench.get_child_count() - 1) as DropNode
		droppable.add_child(card)
		card.card_label.text = card_bench_data.name
		card.card_texture_rect.texture = get_card_texture(card_bench_data)
		connect_card_signals(card)


func clear_scene() -> void:
	for child in tier_list.tiers_v_box_container.get_children():
		child.queue_free()
	card_bench.clear_bench()


func set_card_texture_bytes(card_data: CardData, image: Image) -> void:
	card_data.texture_bytes = image.save_png_to_buffer()


func get_card_texture(card_data: CardData) -> ImageTexture:
	if card_data.texture_bytes.is_empty():
		return null
	var image := Image.new()
	var err := image.load_png_from_buffer(card_data.texture_bytes)
	if not err == OK:
		push_error("Failed decoding card texture")
		return null
	return ImageTexture.create_from_image(image)
#endregion Save Management

#region Tierlist Settings
func set_category_settings_window() -> void:
	category_settings_window.close_button.pressed.connect(close_category_settings_window)
	category_settings_window.close_texture_button.pressed.connect(close_category_settings_window)


func connect_tier_category_signals(tier_category: TierCategory) -> void:
	tier_category.category_settings.settings_texture_button.pressed \
		.connect(
			_on_category_settings_texture_button_pressed
			.bind(tier_category)
		)
	tier_category.category_settings.up_texture_button.pressed \
		.connect(
			_on_category_settings_up_texture_button_pressed
			.bind(tier_category)
		)
	tier_category.category_settings.down_texture_button.pressed \
		.connect(
			_on_category_settings_down_texture_button_pressed
			.bind(tier_category)
		)


func close_category_settings_window() -> void:
	category_settings_window.hide()
	category_settings_window.tier_name_line_edit.text = ""
	category_settings_window.tier_name_line_edit.text_changed.disconnect(_on_tier_name_changed)
	category_settings_window.tier_color_picker_button.color_changed.disconnect(_on_tier_color_picker_button_color_changed)
	category_settings_window.add_above_button.pressed.disconnect(_on_add_above_button_pressed)
	category_settings_window.add_below_button.pressed.disconnect(_on_add_below_button_pressed)
	category_settings_window.remove_button.pressed.disconnect(_on_remove_button_pressed)


func _on_category_settings_texture_button_pressed(tier_category: TierCategory) -> void:
	category_settings_window.show()
	category_settings_window.tier_name_line_edit.text = tier_category.tier_name.tier_label.text
	category_settings_window.tier_name_line_edit.text_changed \
		.connect(
			_on_tier_name_changed
			.bind(tier_category)
			)
	category_settings_window.tier_color_picker_button.color \
		= tier_category.tier_name.background_color_rect.color
	category_settings_window.tier_color_picker_button.color_changed \
		.connect(
			_on_tier_color_picker_button_color_changed
			.bind(tier_category)
			)
	category_settings_window.add_above_button.pressed \
		.connect(
			_on_add_above_button_pressed
			.bind(tier_category)
			)
	category_settings_window.add_below_button.pressed \
		.connect(
			_on_add_below_button_pressed
			.bind(tier_category)
			)
	category_settings_window.remove_button.pressed \
		.connect(
			_on_remove_button_pressed
			.bind(tier_category)
			)


func _on_tier_name_changed(new_text: String, tier_category: TierCategory) -> void:
	tier_category.tier_name.tier_label.text = new_text


func _on_tier_color_picker_button_color_changed(color: Color, tier_category: TierCategory) -> void:
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
	close_category_settings_window()


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

#region Card Settings
func set_card_settings_window() -> void:
	card_settings_window.close_texture_button.pressed.connect(close_card_settings_window)
	card_settings_window.close_button.pressed.connect(close_card_settings_window)


func set_upload_file_dialog() -> void:
	upload_file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	upload_file_dialog.use_native_dialog = true
	upload_file_dialog.mode = Window.MODE_WINDOWED
	upload_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	upload_file_dialog.filters = ["*.*"]
	upload_file_dialog.title = "Upload an Image"


func close_card_settings_window() -> void:
	card_settings_window.hide()
	card_settings_window.card_line_edit.text = ""
	card_settings_window.card_line_edit.text_changed \
		.disconnect(
			_on_card_settings_window_card_line_edit_text_changed
		)
	card_settings_window.upload_image_button.pressed \
		.disconnect(
			_on_card_settings_window_upload_image_button_pressed
		)
	card_settings_window.clear_image_button.pressed \
		.disconnect(
			_on_card_settings_window_clear_image_button_pressed
		)
	card_settings_window.delete_button.pressed \
		.disconnect(
			_on_card_settings_window_delete_button_pressed
		)
	upload_file_dialog.file_selected \
		.disconnect(
			_on_upload_file_dialog_file_selected
		)


func _on_card_creator_card_created(card: Card) -> void:
	connect_card_signals(card)


func connect_card_signals(card: Card) -> void:
	card.options_texture_button.pressed \
	.connect(
		_on_card_options_texture_button_pressed
		.bind(card)
		)


func _on_card_options_texture_button_pressed(card: Card) -> void:
	card_settings_window.show()
	card_settings_window.card_line_edit.text = card.card_label.text
	card_settings_window.card_line_edit.text_changed \
		.connect(
			_on_card_settings_window_card_line_edit_text_changed
			.bind(card)
		)
	card_settings_window.upload_image_button.pressed \
		.connect(
			_on_card_settings_window_upload_image_button_pressed
		)
	card_settings_window.clear_image_button.pressed \
		.connect(
			_on_card_settings_window_clear_image_button_pressed
			.bind(card)
		)
	card_settings_window.delete_button.pressed \
		.connect(
			_on_card_settings_window_delete_button_pressed
			.bind(card)
		)
	upload_file_dialog.file_selected \
		.connect(
			_on_upload_file_dialog_file_selected
			.bind(card)
		)


func _on_card_settings_window_card_line_edit_text_changed(new_text: String, card: Card) -> void:
	card.card_label.text = new_text


func _on_card_settings_window_delete_button_pressed(card: Card) -> void:
	card.queue_free()
	close_card_settings_window()


func _on_card_settings_window_upload_image_button_pressed() -> void:
	upload_file_dialog.popup_centered()


func _on_upload_file_dialog_file_selected(path: String, card: Card) -> void:
	var image := Image.load_from_file(path)
	if image == null:
		return
	var target_size := Vector2i(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y)
	image.resize(target_size.x, target_size.y, Image.INTERPOLATE_LANCZOS)
	card.card_texture_rect.texture = ImageTexture.create_from_image(image)


func _on_card_settings_window_clear_image_button_pressed(card: Card) -> void:
	card.card_texture_rect.texture = null
	card.background_panel_container.show()
#endregion Card Settings
