extends Node

const dungeon_scene: PackedScene = preload("res://Scenes/Game/dungeon.tscn")
const main_menu_scene: PackedScene = preload("res://Scenes/Game/main_menu.tscn")

var current_child: Node

func switch_to_scene(scene: PackedScene) -> Node:
	if current_child != null:
		current_child.queue_free()
	current_child = scene.instantiate()
	add_child(current_child)
	return current_child

func load_main_menu() -> void:
	var main_menu: MainMenu = switch_to_scene(main_menu_scene)
	main_menu.game_requested.connect(_on_game_requested)

func _on_game_requested(try_load: bool) -> void:
	var game: Dungeon = switch_to_scene(dungeon_scene)
	game.main_menu_requested.connect(load_main_menu)
	game.init_game(try_load)

func _ready():
	load_main_menu()
