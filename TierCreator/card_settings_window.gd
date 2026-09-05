@tool
class_name CardSettingsWindow
extends PanelContainer

@onready var close_texture_button: TextureButton = %CloseTextureButton
@onready var card_label: Label = %CardLabel
@onready var card_line_edit: LineEdit = %CardLineEdit
@onready var close_button: Button = %CloseButton
@onready var upload_image_button: Button = %UploadImageButton
@onready var clear_image_button: Button = %ClearImageButton
@onready var delete_button: Button = %DeleteButton

func _ready() -> void:
	set_self()
	set_close_texture_button()
	set_close_button()


func set_self() -> void:
	hide()


func set_close_texture_button() -> void:
	close_texture_button.ignore_texture_size = true
	close_texture_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
	close_texture_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	close_texture_button.custom_minimum_size = Vector2(32.0, 32.0)


func set_close_button() -> void:
	close_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
