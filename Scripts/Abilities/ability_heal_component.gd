class_name AbilityHealComponent extends AbilityComponent

@export var heal_mod: float = 1.0

func perform(action: AbilityAction):
	print("Ding")
	var entity = action.entity	
	for target in action.targets:
		@warning_ignore("narrowing_conversion")
		var amount_recovered: int = target.fighter_component.heal(heal_mod)
		var heal_description: String 
		if target == entity:
			heal_description = "%s heals themselves" % entity.get_entity_name()
		else:
			heal_description = "%s heals %s" % [entity.get_entity_name(), target.get_entity_name()]
			
		if amount_recovered > 0:
			heal_description += " for %d HP!" % amount_recovered
			MessageLog.send_message(heal_description, GameColors.HEALTH_RECOVERED)
		else:
			heal_description += " but their health was full."
			MessageLog.send_message(heal_description, GameColors.IMPOSSIBLE)
	return true
