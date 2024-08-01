class_name TurnAction extends Action

var direction: int

@warning_ignore("shadowed_variable")
func _init(_entity: Entity, direction: int) -> void:
	super._init(_entity)
	self.direction = direction

func perform() -> bool:
	entity.turn_towards(direction)
	return false
