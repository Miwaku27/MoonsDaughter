class_name ItemComponent extends Component

var consumed: bool = true

func get_action(_consumer: Entity) -> Action:
	return null

func activate(_action: ItemAction) -> bool:
	return false

func remove_from(consumer: Entity) -> void:
	var inventory: InventoryComponent = consumer.inventory_component
	inventory.items.erase(entity)
	entity.queue_free()
