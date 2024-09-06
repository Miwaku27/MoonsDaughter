class_name GameMenu extends Control

signal game_menu_completed

var game: Dungeon

const settings_scene: PackedScene = preload("res://Scenes/GUI/settings_menu.tscn")

func setup(dungeon: Dungeon) -> void:
	game = dungeon

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("cancel") or Input.is_action_just_pressed("6"):
		_on_cancel_button_pressed()
	elif Input.is_action_just_pressed("0"):
		_on_save_button_pressed()
	elif Input.is_action_just_pressed("1"):
		_on_settings_button_pressed()
	elif Input.is_action_just_pressed("4"):
		_on_quit_menu_button_pressed()
	elif Input.is_action_just_pressed("5"):
		_on_quit_game_button_pressed()

func _on_save_button_pressed():
	game.save_game()
	_on_cancel_button_pressed()

func _on_settings_button_pressed():
	var settings = settings_scene.instantiate()
	add_child(settings)
	settings.setup()
	set_physics_process(false)
	await settings.settings_completed
	set_physics_process.bind(true).call_deferred()

func _on_quit_menu_button_pressed():
	game.save_game()
	game._on_escape_requested()

func _on_quit_game_button_pressed():
	game.save_game()
	get_tree().quit()

func _on_cancel_button_pressed():
	queue_free()
	game_menu_completed.emit()


