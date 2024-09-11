class_name ConsumableComponent extends ItemComponent

var ability: AbilityDefinition

func _init(definition: ConsumableDefinition) -> void:
	ability = definition.ability

func get_action(consumer: Entity) -> Action:
	return ConsumeAction.new(consumer, entity)
	#var action = ItemAction.new(consumer, entity)
	#if ability:
	#	return ability.perform(action)
	#else:
	#	return action


func activate(_action: ItemAction) -> bool:
	return false

func consume(consumer: Entity) -> void:
	var inventory: InventoryComponent = consumer.inventory_component
	inventory.items.erase(entity)
	entity.queue_free()
