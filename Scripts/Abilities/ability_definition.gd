class_name AbilityDefinition extends Resource

@export var id: String
@export var name: String = "Unnamed Ability"

@export var max_range: int = 1
@export var zone: int = 1

@export var require_target = true

@export var components: Array[AbilityComponent]
