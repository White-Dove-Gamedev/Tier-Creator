@tool
class_name Card
extends Control

@onready var card_texture_rect: TextureRect = %CardTextureRect
@onready var card_label: Label = %CardLabel
@onready var options_texture_button: TextureButton = %OptionsTextureButton
@onready var background_panel_container: PanelContainer = %BackgroundPanelContainer

func _ready() -> void:
	set_self()
	set_card_label()
	set_card_texture_rect()
	set_background_panel_container()
	set_options_texture_button()


func set_self() -> void:
	custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	custom_maximum_size = Vector2(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y)
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_entered.connect(_on_card_mouse_entered)
	mouse_exited.connect(_on_card_mouse_exited)


func set_card_label() -> void:
	card_label.custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	card_label.custom_maximum_size = Vector2(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y)


func set_card_texture_rect() -> void:
	card_texture_rect.custom_minimum_size = Vector2(Utils.MIN_SIZE_X, Utils.MIN_SIZE_Y)
	card_texture_rect.custom_maximum_size = Vector2(Utils.MAX_SIZE_X, Utils.MAX_SIZE_Y)


func set_background_panel_container() -> void:
	background_panel_container.mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_options_texture_button() -> void:
	options_texture_button.hide()
	options_texture_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	options_texture_button.ignore_texture_size = true
	options_texture_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	options_texture_button.mouse_filter = Control.MOUSE_FILTER_PASS
	options_texture_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	options_texture_button.custom_minimum_size = Vector2(Utils.MIN_SIZE_X / 2.5, Utils.MIN_SIZE_Y / 2.5)


func _on_card_mouse_entered() -> void:
	options_texture_button.show()


func _on_card_mouse_exited() -> void:
	options_texture_button.hide()
