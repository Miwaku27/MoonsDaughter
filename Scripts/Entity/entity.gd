class_name Entity
extends Sprite3D

enum AIType {NONE, HOSTILE}
enum EntityType {CORPSE, ITEM, ACTOR}

const entity_types = {
	"player": "res://Resources/Entities/entity_definition_player.tres",
	"orc": "res://Resources/Entities/entity_definition_orc.tres",
	"troll": "res://Resources/Entities/entity_definition_troll.tres",
	
	"health_potion": "res://Resources/Items/health_potion_definition.tres",
	"lightning_scroll": "res://Resources/Items/lightning_scroll_definition.tres",
	"confusion_scroll": "res://Resources/Items/confusion_scroll_definition.tres",
	"fireball_scroll": "res://Resources/Items/fireball_scroll_definition.tres",
	
	"dagger": "res://Resources/Items/dagger_definition.tres",
	"sword": "res://Resources/Items/sword_definition.tres",
	"chainmail": "res://Resources/Items/chainmail_definition.tres",
	"leather_armor": "res://Resources/Items/leather_armor_definition.tres",
	
	#"aoe_item": "res://Resources/Items/aoe_item.tres",
}

var key: String

var _definition: EntityDefinition
var entity_name: String
var blocks_movement: bool
var map_data: MapData
var type: EntityType
var mod_color: Color

var fighter_component: FighterComponent
var ai_component: BaseAIComponent
var consumable_component: ConsumableComponent
var equippable_component: EquippableComponent
var inventory_component: InventoryComponent
var level_component: LevelComponent
var equipment_component: EquipmentComponent

var entity_component: Component

var tween : Tween
var height_pos = 0.75

var grid_position: Vector2i:
	set(value):
		if self.is_inside_tree():
			if tween:
				tween.kill()
			tween = create_tween()
			tween.tween_property(self, "position", Vector3(value.x, height_pos, value.y), .15)
		else:
			position = Vector3(value.x, height_pos, value.y)
		grid_position = value
	get:
		return grid_position

@onready var icon = $Icon

func _ready():
	if _definition:
		icon.texture = _definition.icon_texture
		icon.modulate = _definition.icon_color

@warning_ignore("shadowed_variable")
func initialize(_map_data: MapData, start_position: Vector2i, key: String = "") -> void:
	#centered = true
	#pixel_size = 0.0015
	#offset.y = 500
	grid_position = start_position
	map_data = _map_data
	SignalBus.player_turned.connect(turn)
	if key != "":
		set_entity_type(key)
	#init_selection()

func move(move_offset: Vector2i) -> void:
	map_data.unregister_blocking_entity(self)
	grid_position += move_offset
	map_data.register_blocking_entity(self)
	
@warning_ignore("shadowed_variable")
func set_entity_type(key: String) -> void:
	self.key = key
	var entity_definition: EntityDefinition = Database.entities[key]
	_definition = entity_definition
	type = _definition.type()
	blocks_movement = _definition.is_blocking_movement()
	entity_name = _definition.name
	texture = entity_definition.texture
	mod_color = entity_definition.color
	modulate = mod_color
	if icon:
		icon.texture = entity_definition.icon_texture
		icon.modulate = entity_definition.icon_color
	
	entity_component = entity_definition.create_entity_component()
	if entity_component:
		add_child(entity_component)
		entity_component.entity = self
		return
	
	match entity_definition.ai_type:
		AIType.HOSTILE:
			ai_component = HostileEnemyAIComponent.new()
			add_child(ai_component)
	
	if entity_definition.fighter_definition:
		fighter_component = FighterComponent.new(entity_definition.fighter_definition)
		add_child(fighter_component)
		
	var item_definition: ItemComponentDefinition = entity_definition.item_definition
	if item_definition:
		if item_definition is ConsumableComponentDefinition:
			_handle_consumable(item_definition)
		#else:
			#equippable_component = EquippableComponent.new(item_definition)
		
	if entity_definition.inventory_capacity > 0:
		inventory_component = InventoryComponent.new(entity_definition.inventory_capacity)
		add_child(inventory_component)
	
	if entity_definition.level_info:
		level_component = LevelComponent.new(entity_definition.level_info)
		add_child(level_component)
	
	if entity_definition.has_equipment:
		equipment_component = EquipmentComponent.new()
		add_child(equipment_component)
		equipment_component.entity = self

func _handle_consumable(consumable_definition: ConsumableComponentDefinition) -> void:
	if consumable_definition is HealingConsumableComponentDefinition:
		consumable_component = HealingConsumableComponent.new(consumable_definition)
	elif consumable_definition is LightningDamageConsumableComponentDefinition:
		consumable_component = LightningDamageConsumableComponent.new(consumable_definition)
	#elif consumable_definition is ConfusionConsumableComponentDefinition:
	#	consumable_component = ConfusionConsumableComponent.new(consumable_definition)
	elif consumable_definition is FireballDamageConsumableComponentDefinition:
		consumable_component = FireballDamageConsumableComponent.new(consumable_definition)
	
	if consumable_component:
		add_child(consumable_component)
	consumable_component.entity = self

func is_blocking_movement() -> bool:
	return blocks_movement

func get_entity_name() -> String:
	return entity_name

func is_alive() -> bool:
	return ai_component != null

func distance(other_position: Vector2i) -> int:
	var relative: Vector2i = other_position - grid_position
	return maxi(abs(relative.x), abs(relative.y))

func turn_towards(_dir : int):
	pass

func turn(angle : float, tween_rotation := true):
	if get_parent() and tween_rotation:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "rotation", Vector3(0, angle , 0), .15)
	else:
		rotation = Vector3(0, angle , 0)

func highlight(_selection_color):
	pass

func remove_highlight():
	pass

func use_item(item: Entity):
	var comp = item.entity_component
	if comp is ConsumableComponent:
		#%AbilityInputManager.select_item(item)
		SignalBus.use_item.emit(item)
		return null
	else:
		return EquipAction.new(self, item)

#Save & Load
func get_save_data() -> Dictionary:
	var save_data: Dictionary = {
		"x": grid_position.x,
		"y": grid_position.y,
		"key": key,
	}
	if fighter_component:
		save_data["fighter_component"] = fighter_component.get_save_data()
	if ai_component:
		save_data["ai_component"] = ai_component.get_save_data()
	if inventory_component:
		save_data["inventory_component"] = inventory_component.get_save_data()
	if equipment_component:
		save_data["equipment_component"] = equipment_component.get_save_data()
	if level_component:
		save_data["level_component"] = level_component.get_save_data()
	return save_data

func restore(save_data: Dictionary) -> void:
	grid_position = Vector2i(save_data["x"], save_data["y"])
	set_entity_type(save_data["key"])
	if fighter_component and save_data.has("fighter_component"):
		fighter_component.restore(save_data["fighter_component"])
	if ai_component and save_data.has("ai_component"):
		var ai_data: Dictionary = save_data["ai_component"]
		if ai_data["type"] == "ConfusedEnemyAI":
			var confused_enemy_ai := ConfusedEnemyAIComponent.new(ai_data["turns_remaining"])
			add_child(confused_enemy_ai)
	if inventory_component and save_data.has("inventory_component"):
		inventory_component.restore(save_data["inventory_component"])
	if equipment_component and save_data.has("equipment_component"):
		equipment_component.restore(save_data["equipment_component"])
	if level_component and save_data.has("level_component"):
		level_component.restore(save_data["level_component"])
