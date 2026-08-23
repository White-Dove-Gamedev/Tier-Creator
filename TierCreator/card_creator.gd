@tool
class_name CardCreator
extends PanelContainer

const CARD = preload("uid://cpyj3ex8t8ttf")

@onready var preview_h_box_container: HBoxContainer = %PreviewHBoxContainer
@onready var preview_panel_container: PanelContainer = %PreviewPanelContainer
@onready var preview_texture_rect: TextureRect = %PreviewTextureRect
@onready var preview_label: Label = %PreviewLabel
@onready var create_card_button: Button = %CreateCardButton
@onready var card_text_line_edit: LineEdit = %CardTextLineEdit
@onready var upload_image_button: Button = %UploadImageButton
@onready var clear_image_button: Button = %ClearImageButton

var file_dialog = FileDialog.new()

func _ready() -> void:
	set_sizes()
	set_mouse_settings()
	connect_signals()
	set_file_dialog()


func _on_create_card_button_pressed() -> void:
	var card: Card = CARD.instantiate()
	var card_layer := get_tree().get_first_node_in_group("card_layer") as CardLayer
	if not card_layer:
		push_error("Missing CardLayer node in scene tree")
		return
	card_layer.add_child(card)
	card.position = preview_panel_container.global_position
	card.card_label.text = preview_label.text
	card.card_texture_rect.texture = preview_texture_rect.texture
	if card.card_texture_rect.texture:
		card.background_panel_container.hide()
	card.move_to_front()



func _on_card_text_line_edit_text_changed(new_text: String) -> void:
	preview_label.text = new_text


func _on_upload_image_button_pressed() -> void:
	file_dialog.popup_centered()


func _on_file_selected(path: String) -> void:
	var image := Image.load_from_file(path)
	if image == null:
		return
	preview_texture_rect.texture = ImageTexture.create_from_image(image)


func _on_clear_image_button_pressed() -> void:
	preview_texture_rect.texture = null


func set_sizes() -> void:
	preview_label.custom_minimum_size = Vector2(96.0, 96.0)
	preview_label.custom_maximum_size = Vector2(96.0, 96.0)
	preview_texture_rect.custom_minimum_size = Vector2(96.0, 96.0)
	preview_texture_rect.custom_maximum_size = Vector2(96.0, 96.0)
	preview_panel_container.custom_minimum_size = Vector2(96.0, 96.0)
	preview_panel_container.custom_maximum_size = Vector2(96.0, 96.0)


func set_mouse_settings() -> void:
	create_card_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	upload_image_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	clear_image_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	preview_panel_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview_texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview_h_box_container.mouse_filter = Control.MOUSE_FILTER_IGNORE



func connect_signals() -> void:
	card_text_line_edit.text_changed.connect(_on_card_text_line_edit_text_changed)
	upload_image_button.pressed.connect(_on_upload_image_button_pressed)
	clear_image_button.pressed.connect(_on_clear_image_button_pressed)
	create_card_button.pressed.connect(_on_create_card_button_pressed)


func set_file_dialog() -> void:
	add_child(file_dialog)
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.use_native_dialog = true
	file_dialog.mode = Window.MODE_WINDOWED
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.filters = ["*.*"]
	file_dialog.title = "Upload a texture"

	file_dialog.file_selected.connect(_on_file_selected)
