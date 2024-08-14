class_name AbilityDamageComponent extends AbilityComponent

@export var damage_mod: float = 1.0

func perform(action: AbilityAction):
	var attack_color: Color	
	var entity = action.entity
	if entity is Player:
		attack_color = GameColors.PLAYER_ATTACK
	else:
		attack_color = GameColors.ENEMY_ATTACK
	
	for target in action.targets:
		var damage: int = (entity.fighter_component.power - target.fighter_component.defense) * damage_mod
		var attack_description: String = "%s attacks %s" % [entity.get_entity_name(), target.get_entity_name()]
		if damage > 0:
			attack_description += " for %d hit points." % damage
			MessageLog.send_message(attack_description, attack_color)
			target.fighter_component.hp -= damage
		else:
			attack_description += " but does no damage."
			MessageLog.send_message(attack_description, attack_color)
		SignalBus.target_entity.emit(target)
