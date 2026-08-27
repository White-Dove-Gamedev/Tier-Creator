@tool
class_name CategorySettings
extends AspectRatioContainer

@onready var settings_texture_button: TextureButton = %SettingsTextureButton
@onready var up_texture_button: TextureButton = %UpTextureButton
@onready var down_texture_button: TextureButton = %DownTextureButton
@onready var move_buttons_v_box_container: VBoxContainer = %MoveButtonsVBoxContainer
@onready var settings_h_box_container: HBoxContainer = %SettingsHBoxContainer

func _ready() -> void:
	setup()


func setup() -> void:
	set_self()
	set_up_texture_button()
	set_down_texture_button()
	set_settings_texture_button()
	set_settings_h_box_container()
	set_move_buttons_v_box_container()


func set_self() -> void:
	custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	custom_maximum_size = Vector2(Utils.MAX_SIZE_X, -1.0)
	size_flags_vertical = Control.SIZE_EXPAND_FILL


func set_up_texture_button() -> void:
	up_texture_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	up_texture_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	up_texture_button.size_flags_vertical = Control.SIZE_EXPAND_FILL


func set_down_texture_button() -> void:
	down_texture_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	down_texture_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	down_texture_button.size_flags_vertical = Control.SIZE_EXPAND_FILL


func set_settings_texture_button() -> void:
	settings_texture_button.custom_minimum_size = Vector2(Utils.MIN_SIZE_X * 0.75, -1.0)
	settings_texture_button.stretch_mode = TextureButton.STRETCH_KEEP_CENTERED
	settings_texture_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	settings_texture_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	settings_texture_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	settings_texture_button.ignore_texture_size = true


func set_settings_h_box_container() -> void:
	settings_h_box_container.add_theme_constant_override(&"separation", 0)


func set_move_buttons_v_box_container() -> void:
	custom_minimum_size = Vector2(Utils.MIN_SIZE_X / 4, -1.0)
	move_buttons_v_box_container.add_theme_constant_override(&"separation", 0)
