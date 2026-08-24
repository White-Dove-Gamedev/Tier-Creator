@tool
class_name Card
extends Control

@onready var card_texture_rect: TextureRect = %CardTextureRect
@onready var card_label: Label = %CardLabel
@onready var delete_button: Button = %DeleteButton
@onready var background_panel_container: PanelContainer = %BackgroundPanelContainer

func _ready() -> void:
	set_sizes()
	set_mouse_filters()
	set_theme_override()
	connect_signals()


func set_sizes() -> void:
	card_label.custom_minimum_size = Vector2(96.0, 96.0)
	card_label.custom_maximum_size = Vector2(96.0, 96.0)
	card_texture_rect.custom_minimum_size = Vector2(96.0, 96.0)
	card_texture_rect.custom_maximum_size = Vector2(96.0, 96.0)
	custom_minimum_size = Vector2(96.0, 96.0)
	custom_maximum_size = Vector2(96.0, 96.0)


func set_mouse_filters() -> void:
	delete_button.mouse_filter = Control.MOUSE_FILTER_PASS
	delete_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	background_panel_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_filter = Control.MOUSE_FILTER_PASS


func connect_signals() -> void:
	mouse_entered.connect(_on_card_mouse_entered)
	mouse_exited.connect(_on_card_mouse_exited)
	delete_button.pressed.connect(_on_delete_button_pressed)


func set_theme_override() -> void:
	card_label.add_theme_constant_override(&"line_spacing", 0)
	card_label.add_theme_constant_override(&"outline_size", 4)


func _on_card_mouse_entered() -> void:
	delete_button.show()


func _on_card_mouse_exited() -> void:
	delete_button.hide()


func _on_delete_button_pressed() -> void:
	if Input.is_action_just_released(&"mouse_button_left"):
		queue_free()
