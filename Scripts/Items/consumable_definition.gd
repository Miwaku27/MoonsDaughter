class_name ConsumableDefinition extends ItemDefinition


@export var ability: AbilityDefinition


func create_entity_component():
	return ConsumableComponent.new(self)
