@tool
class_name SettingsWindow
extends PanelContainer

@onready var close_texture_button: TextureButton = %CloseTextureButton
@onready var close_button: Button = %CloseButton
@onready var tier_name_line_edit: LineEdit = %TierNameLineEdit
@onready var tier_color_line_edit: LineEdit = %TierColorLineEdit
@onready var add_above_label: Button = %AddAboveLabel
@onready var add_below_label: Button = %AddBelowLabel

func _ready() -> void:
	set_close_texture_button()
	set_close_button()


func set_close_texture_button() -> void:
	close_texture_button.custom_minimum_size = Vector2(32.0, 32.0)
	close_texture_button.custom_maximum_size = Vector2(32.0, 32.0)
	close_texture_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	close_texture_button.size_flags_horizontal = Control.SIZE_SHRINK_END
	close_texture_button.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	close_texture_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND


func set_close_button() -> void:
	close_button.text = "close"
	close_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	close_button.size_flags_vertical = Control.SIZE_SHRINK_END
	close_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
