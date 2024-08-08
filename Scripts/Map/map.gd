class_name Map extends Node3D

signal dungeon_floor_changed(floor)

@export var fov_radius: int = 8

var map_data: MapData

@onready var tiles : Node3D = $Tiles
@onready var entities : Node3D = $Entities
@onready var dungeon_generator: DungeonGenerator = $DungeonGenerator
@onready var field_of_view: FieldOfView = $FieldOfView

var player : Player
var highlights = []

func _ready() -> void:
	SignalBus.player_descended.connect(next_floor)
	SignalBus.target_entered.connect(target_at_position)
	SignalBus.target_exited.connect(untarget_at_position)

func generate(_player: Player, current_floor: int = 1) -> void:
	player = _player
	map_data = dungeon_generator.generate_dungeon(player, current_floor)
	map_data.entity_placed.connect(entities.add_child)
	_place_tiles()
	_place_entities()
	dungeon_floor_changed.emit(current_floor)

func _place_tiles() -> void:
	for tile in map_data.tiles:
		tiles.add_child(tile)
		
func _place_entities() -> void:
	for entity in map_data.entities:
		entities.add_child(entity)
		
func update_fov(player_position: Vector2i) -> void:
	field_of_view.update_fov(map_data, player_position, fov_radius)
	
	for entity in map_data.entities:
		entity.visible = map_data.get_tile(entity.grid_position).is_in_view

func next_floor() -> void:
	#var player: Entity = map_data.player
	entities.remove_child(player)
	for entity in entities.get_children():
		entity.queue_free()
	for tile in tiles.get_children():
		tile.queue_free()
	generate(player, map_data.current_floor + 1)
	#player.get_node("Camera3D").make_current()
	field_of_view.reset_fov()
	update_fov(player.grid_position)

func distance(first_position: Vector2i, other_position: Vector2i) -> int:
	var relative: Vector2i = other_position - first_position
	return maxi(abs(relative.x), abs(relative.y))

func target_at_position(grid_position, radius = 1, selection_color = Color.MEDIUM_PURPLE):
	for highlight in highlights:
		if highlight:
			highlight.remove_highlight()
	
	highlights = []
	var tile = map_data.get_tile(grid_position)
	tile.highlight(selection_color)
	highlights.append(tile)
	var entity = map_data.get_blocking_entity_at_location(grid_position)
	if entity:
		entity.highlight(selection_color)
		highlights.append(entity)
	if radius > 1:
		for map_tile in map_data.get_tiles():
			if distance(map_tile.grid_position, grid_position) <= radius:
				map_tile.highlight(selection_color)
				highlights.append(map_tile)
		for actor in map_data.get_actors():
			if actor.distance(grid_position) <= radius:
				actor.highlight(selection_color)
				highlights.append(actor)

func untarget_at_position(_grid_position, _radius = 2):
	pass
	#map_data.get_tile(grid_position).remove_highlight()
	#var entity = map_data.get_blocking_entity_at_location(grid_position)
	#if entity:
	#	entity.remove_highlight()
	#if radius > 1:
	#	for tile in map_data.get_tiles():
	#		if distance(tile.grid_position, grid_position) <= radius:
	#			tile.remove_highlight()
	#	for actor in map_data.get_actors():
	#		if actor.distance(grid_position) <= radius:
	#			actor.remove_highlight()

#Save & Load
func load_game(_player: Entity) -> bool:
	player = _player
	map_data = MapData.new(0, 0, player)
	map_data.entity_placed.connect(entities.add_child)
	if not map_data.load_game():
		return false
	_place_tiles()
	_place_entities()
	dungeon_floor_changed.emit(map_data.current_floor)
	return true
