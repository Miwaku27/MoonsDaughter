class_name TileDefinition extends Resource

@export_category("Visuals")
@export var mesh: Mesh
@export var darkness_material : Material
@export var selection_material : Material

@export_category("Mechanics")
@export var is_walkable: bool = true
@export var is_transparent: bool = true
@export var hitbox_height: float = 0
