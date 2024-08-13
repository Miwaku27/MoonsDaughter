class_name AbilityAction extends Action

var ability: AbilityDefinition
var target: Array

func _init(_entity: Entity, ability_def: AbilityDefinition, ability_target: Array) -> void:
	super._init(_entity)
	ability = ability_def
	target = ability_target

func perform() -> bool:
	if ability.zone > 0:
		print("Tile")
	elif ability.zone == 0:
		print("Self")
	else:
		print("Ally")
	return true
