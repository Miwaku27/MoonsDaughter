class_name PickupAction extends Action


func perform() -> bool:
	var inventory: InventoryComponent = entity.inventory_component
	var map_data: MapData = get_map_data()
	
	if entity.grid_position == get_map_data().down_stairs_location:
		SignalBus.player_descended.emit()
		MessageLog.send_message("You descend the staircase.", GameColors.DESCEND)
		return false
	else:
		for item in map_data.get_items():
			if entity.grid_position == item.grid_position:
				if inventory.items.size() >= inventory.capacity:
					MessageLog.send_message("Your inventory is full.", GameColors.IMPOSSIBLE)
					return false
				
				map_data.entities.erase(item)
				item.get_parent().remove_child(item)
				inventory.items.append(item)
				MessageLog.send_message(
					"You picked up the %s!" % item.get_entity_name(),
					Color.WHITE
				)
				return true
	
	MessageLog.send_message("There is nothing here.", GameColors.IMPOSSIBLE)
	return false
