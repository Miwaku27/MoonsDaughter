class_name EquipableDefinition extends ItemDefinition

@export var equipment_type: EquippableComponent.EquipmentType
@export var power_bonus: int = 0
@export var defense_bonus: int = 0


func create_entity_component():
	return EquippableComponent.new(self)
