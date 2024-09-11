class_name ItemDefinition extends EntityDefinition


func is_blocking_movement() -> bool:
	return false
func type() -> Entity.EntityType:
	return Entity.EntityType.ITEM
