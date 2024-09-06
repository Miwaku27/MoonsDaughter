class_name GameMenu extends Control

signal game_menu_completed

var game: Dungeon

func setup(dungeon: Dungeon) -> void:
	game = dungeon


func _on_save_button_pressed():
	game.save_game()
	_on_cancel_button_pressed()

func _on_quit_menu_button_pressed():
	game.save_game()
	game._on_escape_requested()

func _on_quit_game_button_pressed():
	game.save_game()
	get_tree().quit()

func _on_cancel_button_pressed():
	queue_free()
	game_menu_completed.emit()
