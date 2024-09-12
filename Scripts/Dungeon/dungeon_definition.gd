class_name DungeonDefinition extends Resource

@export_category("Visuals")
@export var name: String = "Unnamed Dungeon"

@export_category("Map Dimensions")
@export var map_width: int = 80
@export var map_height: int = 45

@export_category("Floors RNG")
@export var max_items_by_floor = [
	[1, 1],
	[4, 2]
]
@export var max_monsters_by_floor = [
	[1, 2],
	[4, 3],
	[6, 5]
]

@export_category("Rooms RNG")
@export var max_rooms: int = 10
@export var room_max_size: int = 10
@export var room_min_size: int = 6

@export_category("Spawns RNG")
@export var enemy_chances = {
	0: {"orc": 80},
	3: {"troll": 15},
	5: {"troll": 30},
	7: {"troll": 60}
}

@export var item_chances = {
	0: {"health_potion": 35},
	2: {"confusion_scroll": 10},
	4: {"lightning_scroll": 25, "sword": 5},
	6: {"fireball_scroll": 25, "chainmail": 15},
}
