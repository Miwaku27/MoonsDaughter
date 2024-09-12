class_name ConfusionAbilityComponent
extends AbilityComponent

@export var number_of_turns: int


func perform(action: AbilityAction):	
	for target in action.targets:
		MessageLog.send_message("The eyes of the %s look vacant, as it starts to stumble around!" % target.get_entity_name(), GameColors.STATUS_EFFECT_APPLIED)
		target.add_child(ConfusedEnemyAIComponent.new(number_of_turns))
	return true
