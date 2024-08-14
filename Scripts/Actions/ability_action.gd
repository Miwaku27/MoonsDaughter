class_name AbilityAction extends Action

var ability: AbilityDefinition
var target_tiles: Array
var targets: Array[Entity]
var grid_position: Vector2i
var map: Map

func _init(_entity: Entity, ability_def: AbilityDefinition, ability_target: Array, position: Vector2i, _map: Map) -> void:
	super._init(_entity)
	ability = ability_def
	target_tiles = ability_target
	grid_position = position
	map = _map

func perform() -> bool:
	targets = []
	var targeting = AbilityTargetingComponent.new(ability.zone)
	targeting.perform(self)
	
	for component in ability.components:
		component.perform(self)
	return true
