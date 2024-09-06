class_name SettingsMenu extends Control

signal settings_completed
@onready var window_button = $VBoxContainer/CenterContainer/PanelContainer/VBoxContainer/WindowButton

var window_mode: DisplayServer.WindowMode

func setup() -> void:
	window_mode = DisplayServer.window_get_mode()
	write_window_button()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("cancel") or Input.is_action_just_pressed("6"):
		_on_confirm_button_pressed()
	elif Input.is_action_just_pressed("0"):
		_on_window_button_pressed()


func _on_window_button_pressed():
	if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
	elif window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	elif window_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(window_mode)
	write_window_button()

func _on_confirm_button_pressed():
	queue_free()
	settings_completed.emit()

func write_window_button():
	if window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		window_button.text = "[1] Windowed"
	elif window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "[1] Borderless"
	elif window_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		window_button.text = "[1] Fullscreen"
	
