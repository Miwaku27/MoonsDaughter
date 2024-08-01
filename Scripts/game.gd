class_name Game extends Node3D

signal player_created(player)
signal main_menu_requested

@onready var player: Player = $Player
@onready var camera = %Camera
@onready var input_handler: InputHandler = $InputHandler
@onready var map : Map = $Map
@onready var input_timer = $InputHandler/InputTimer

var player_can_act : bool = true

const level_up_menu_scene: PackedScene = preload("res://Scenes/GUI/level_up_menu.tscn")

const player_definition: EntityDefinition = preload("res://Resources/Entities/entity_definition_player.tres")
const entity_definition: EntityDefinition = preload("res://Resources/Entities/entity_definition.tres")


func init_game(load_data : bool) -> void:
	SignalBus.escape_requested.connect(_on_escape_requested)
	SignalBus.lock_action.connect(_on_lock_action)
	if load_data:
		load_game()
	else:
		new_game()

func new_game() -> void:	
	remove_child(player)
	player.initialize(null, Vector2i.ZERO, "player")
	_add_player_start_equipment("dagger")
	_add_player_start_equipment("leather_armor")
	player.level_component.level_up_required.connect(_on_player_level_up_requested)
	player_created.emit(player)
	map.generate(player)
	map.update_fov(player.grid_position)
	MessageLog.send_message.bind(
		"Hello and welcome, adventurer, to yet another dungeon!",
		GameColors.WELCOME_TEXT
	).call_deferred()

func _physics_process(_delta: float) -> void:
	if player_can_act:
		var action: Action = await input_handler.get_action(player)
		if action:
			_on_lock_action(.15)
			var _previous_player_position: Vector2i = player.grid_position
			if action.perform():
				_handle_enemy_turns()
				map.update_fov(player.grid_position)

func _on_lock_action(length: float) -> void:
	player_can_act = false
	input_timer.start(length)

func unlock_action() -> void:
	player_can_act = true

func get_map_data() -> MapData:
	return map.map_data

func _handle_enemy_turns() -> void:
	for entity in get_map_data().get_actors():
		if entity.is_alive() and entity != player:
			entity.ai_component.perform()

func _on_escape_requested() -> void:
	main_menu_requested.emit()

func _on_player_level_up_requested() -> void:
	var level_up_menu: LevelUpMenu = level_up_menu_scene.instantiate()
	add_child(level_up_menu)
	level_up_menu.setup(player)
	set_physics_process(false)
	await level_up_menu.level_up_completed
	set_physics_process.bind(true).call_deferred()

func _add_player_start_equipment(item_key: String) -> void:
	var item := EntityManager.create_entity(null, Vector2i.ZERO, item_key)
	player.inventory_component.items.append(item)
	player.equipment_component.toggle_equip(item, false)

#Save & Load
func load_game() -> void:
	remove_child(player)
	player.initialize(null, Vector2i.ZERO, "player")
	if not map.load_game(player):
		main_menu_requested.emit()
	player.level_component.level_up_required.connect(_on_player_level_up_requested)
	player_created.emit(player)
	map.update_fov(player.grid_position)
	player.turn_towards(0)
	MessageLog.send_message.bind(
		"Welcome back, adventurer!",
		GameColors.WELCOME_TEXT
	).call_deferred()
