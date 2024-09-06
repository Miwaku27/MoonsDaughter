class_name CharacterDefinition extends EntityDefinition


func is_blocking_movement() -> bool:
	return true
func type() -> Entity.EntityType:
	return Entity.EntityType.ACTOR
