class_name MainMenu
extends Control

signal game_requested(load)

@onready var first_button: Button = $"%NewButton"
@onready var load_button: Button = $"%LoadButton"

func _ready():
	first_button.grab_focus()
	var has_save_file: bool = FileAccess.file_exists("user://save_game.dat")
	load_button.disabled = not has_save_file

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("0"):
		_on_new_button_pressed()
	elif Input.is_action_just_pressed("1"):
		_on_load_button_pressed()
	elif Input.is_action_just_pressed("4"):
		_on_quit_button_pressed()

func _on_new_button_pressed():
	game_requested.emit(false)


func _on_load_button_pressed():
	game_requested.emit(true)


func _on_quit_button_pressed():
	get_tree().quit()
