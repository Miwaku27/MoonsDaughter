extends Node

var entity_preload = preload("res://Scenes/Assets/entity.tscn")
var tile_preload = preload("res://Scenes/Assets/tile.tscn")

func create_entity(_map_data: MapData, start_position: Vector2i, key: String = "") -> SelectableEntity:
	var entity : SelectableEntity = entity_preload.instantiate()
	entity.initialize(_map_data, start_position, key)
	return entity

func create_tile(grid_position: Vector2i, key: String) -> Tile:
	var tile : Tile = tile_preload.instantiate()
	tile.initialize(grid_position, key)
	return tile
