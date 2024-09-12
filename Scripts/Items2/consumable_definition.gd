class_name ConsumableDefinition extends ItemDefinition


@export var ability: AbilityDefinition
@export var consumed: bool = true


func create_entity_component():
	return ConsumableComponent.new(self)
