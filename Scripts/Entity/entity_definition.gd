class_name EntityDefinition extends Resource

@export_category("Visuals")
@export var id: String
@export var name: String = "Unnamed Entity"
@export var texture: Texture
@export_color_no_alpha var color: Color = Color.WHITE
@export var icon_texture: Texture
@export_color_no_alpha var icon_color: Color = Color.WHITE

#@export_category("Mechanics")
#@export var is_blocking_movement: bool = true
#@export var type: Entity.EntityType = Entity.EntityType.ACTOR

@export_category("Character")
@export var fighter_definition: FighterComponentDefinition
@export var ai_type: Entity.AIType
@export var level_info: LevelComponentDefinition
@export var has_equipment: bool = false

@export_category("Item")
@export var item_definition: ItemComponentDefinition
@export var inventory_capacity: int = 0

func is_blocking_movement() -> bool:
	return true
func type() -> Entity.EntityType:
	return Entity.EntityType.ACTOR
