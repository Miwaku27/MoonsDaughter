class_name ActionWithDirection extends Action

var offset: Vector2i


func _init(_entity: Entity, dx, dy: int = 0) -> void:
	super._init(_entity)
	if dx is Vector2i:
		offset = dx
	else:
		offset = Vector2i(dx, dy)

func get_destination() -> Vector2i:
	return entity.grid_position + offset

func get_blocking_entity_at_destination() -> Entity:
	return get_map_data().get_blocking_entity_at_location(get_destination())

func get_target_actor() -> Entity:
	return get_map_data().get_actor_at_location(get_destination())
