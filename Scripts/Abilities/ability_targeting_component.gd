class_name AbilityTargetingComponent extends AbilityComponent

@export var zone: int = 1

func _init(_zone: int):
	zone = _zone

func perform(action: AbilityAction):
	if action.ability.zone > 0:
		#print("Tile")
		var target
		for tile in action.target_tiles:
			target = action.map.get_entity(tile.grid_position)
			if target:
				action.targets.append(target)
	elif action.ability.zone == 0:
		#print("Self")
		action.targets.append(action.entity)
	else:
		print("Ally")
