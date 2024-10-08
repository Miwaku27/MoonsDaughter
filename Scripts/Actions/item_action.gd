class_name ItemAction extends Action

var item: Entity
var target_position: Vector2i


@warning_ignore("shadowed_variable")
func _init(entity: Entity, item: Entity, target_position = null) -> void:
	super._init(entity)
	self.item = item
	if not target_position is Vector2i:
		target_position = entity.grid_position
	self.target_position = target_position

func get_target_actor() -> Entity:
	return get_map_data().get_actor_at_location(target_position)

func perform() -> bool:
	#if item == null:
		#return false
	#elif item.type == Entity.EntityType.ITEM:
		#return %AbilityInputManager.select_item(item.entity_component)
	#elif item.equippable_component:
		#return EquipAction.new(entity, item).perform()
	#elif item.consumable_component:
		#return item.consumable_component.activate(self)
	#else:
	return false
