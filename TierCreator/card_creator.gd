@tool
class_name CardCreator
extends PanelContainer

signal card_created(card: Card)

const CARD = preload("uid://cpyj3ex8t8ttf")

@onready var preview_h_box_container: HBoxContainer = %PreviewHBoxContainer
@onready var preview_panel_container: PanelContainer = %PreviewPanelContainer
@onready var preview_texture_rect: TextureRect = %PreviewTextureRect
@onready var preview_label: Label = %PreviewLabel
@onready var create_card_button: Button = %CreateCardButton
@onready var card_text_line_edit: LineEdit = %CardTextLineEdit
@onready var upload_image_button: Button = %UploadImageButton
@onready var clear_image_button: Button = %ClearImageButton
@onready var screenshot_texture_button: TextureButton = %ScreenshotTextureButton
@onready var upload_file_dialog: FileDialog = %UploadFileDialog
@onready var save_file_dialog: FileDialog = %SaveFileDialog
@onready var shares_v_box_container: VBoxContainer = %SharesVBoxContainer
@onready var saves_h_box_container: HBoxContainer = %SavesHBoxContainer
@onready var import_texture_button: TextureButton = %ImportTextureButton
@onready var export_texture_button: TextureButton = %ExportTextureButton

func _ready() -> void:
	set_self()
	set_preview_h_box_container()
	set_preview_label()
	set_preview_texture_rect()
	set_preview_panel_container()
	set_screenshot_texture_button()
	set_create_card_button()
	set_card_text_line_edit()
	set_upload_image_button()
	set_clear_image_button()
	set_upload_file_dialog()
	set_save_file_dialog()
	set_shares_v_box_container()
	set_saves_h_box_container()
	set_import_texture_button()
	set_export_texture_button()


func set_self() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_preview_h_box_container() -> void:
	preview_h_box_container.mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_preview_label() -> void:
	preview_label.custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	preview_label.custom_maximum_size = Vector2(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y)
	preview_label.mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_preview_texture_rect() -> void:
	preview_texture_rect.custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	preview_texture_rect.custom_maximum_size = Vector2(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y)
	preview_texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_preview_panel_container() -> void:
	preview_panel_container.custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	preview_panel_container.custom_maximum_size = Vector2(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y)
	preview_panel_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview_panel_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER


func set_screenshot_texture_button() -> void:
	screenshot_texture_button.custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y) / 2
	screenshot_texture_button.custom_maximum_size = Vector2(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y) / 2
	screenshot_texture_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	screenshot_texture_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	screenshot_texture_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func set_create_card_button() -> void:
	create_card_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	create_card_button.pressed.connect(_on_create_card_button_pressed)


func set_card_text_line_edit() -> void:
	card_text_line_edit.backspace_deletes_composite_character_enabled = true
	card_text_line_edit.clear_button_enabled = true
	card_text_line_edit.text_changed.connect(_on_card_text_line_edit_text_changed)
	card_text_line_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL


func set_upload_image_button() -> void:
	upload_image_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	upload_image_button.pressed.connect(_on_upload_image_button_pressed)


func set_clear_image_button() -> void:
	clear_image_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	clear_image_button.pressed.connect(_on_clear_image_button_pressed)


func set_shares_v_box_container() -> void:
	shares_v_box_container.add_theme_constant_override(&"separation", 0)
	shares_v_box_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER


func set_saves_h_box_container() -> void:
	saves_h_box_container.add_theme_constant_override(&"separation", 0)


func set_import_texture_button() -> void:
	import_texture_button.custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y) / 2
	import_texture_button.custom_maximum_size = Vector2(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y) / 2
	import_texture_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func set_export_texture_button() -> void:
	export_texture_button.custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y) / 2
	export_texture_button.custom_maximum_size = Vector2(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y) / 2
	export_texture_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func set_upload_file_dialog() -> void:
	upload_file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	upload_file_dialog.use_native_dialog = true
	upload_file_dialog.mode = Window.MODE_WINDOWED
	upload_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	upload_file_dialog.filters = ["*.*"]
	#upload_file_dialog.filters = ["*.png,*.jpg,*.jpeg"]
	upload_file_dialog.title = "Upload a texture"
	upload_file_dialog.file_selected.connect(_on_upload_file_selected)


func set_save_file_dialog() -> void:
	save_file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_file_dialog.use_native_dialog = true
	save_file_dialog.mode = Window.MODE_WINDOWED
	save_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	save_file_dialog.filters = ["*.png"]
	save_file_dialog.title = "Save the Tierlist"


func _on_upload_file_selected(path: String) -> void:
	var image := Image.load_from_file(path)
	if image == null:
		return
	var target_size := Vector2i(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y)
	image.resize(target_size.x, target_size.y, Image.INTERPOLATE_LANCZOS)
	preview_texture_rect.texture = ImageTexture.create_from_image(image)


func _on_clear_image_button_pressed() -> void:
	preview_texture_rect.texture = null


func _on_card_text_line_edit_text_changed(new_text: String) -> void:
	preview_label.text = new_text


func _on_upload_image_button_pressed() -> void:
	upload_file_dialog.popup_centered()


func _on_create_card_button_pressed() -> void:
	var card: Card = CARD.instantiate()
	var card_bench := get_tree().get_first_node_in_group(&"card_bench") as CardBench
	if not card_bench:
		push_error("Missing CardBench node in scene tree")
		return
	var droppable := card_bench.get_child(card_bench.get_child_count() - 1) as DropNode
	droppable.add_child(card)
	card.position = preview_panel_container.global_position
	card.card_label.text = preview_label.text
	card.card_texture_rect.texture = preview_texture_rect.texture
	if card.card_texture_rect.texture:
		card.background_panel_container.hide()
	card.move_to_front()
	card_created.emit(card)
