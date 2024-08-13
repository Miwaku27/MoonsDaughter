class_name Tile extends MeshInstance3D

const tile_types = {
	"floor": preload("res://Resources/Tiles/tile_definition_floor.tres"),
	"wall": preload("res://Resources/Tiles/tile_definition_wall.tres"),
	"down_stairs": preload("res://Resources/Tiles/tile_definition_down_stairs.tres"),
}

var key: String
var _definition: TileDefinition
var grid_position: Vector2i

@onready var icon = $Icon

var is_explored: bool = false:
	set(value):
		is_explored = value
		if is_explored and not visible:
			visible = true
			
var is_in_view: bool = false:
	set(value):
		is_in_view = value
		set_surface_override_material(0, null if is_in_view else _definition.darkness_material)
		if is_in_view and not is_explored:
			is_explored = true


@warning_ignore("shadowed_variable")
func initialize(grid_position: Vector2i, key: String) -> void:
	visible = false
	self.grid_position = grid_position
	position = Vector3i(grid_position.x, 0, grid_position.y)
	set_tile_type(key)

@warning_ignore("shadowed_variable")
func set_tile_type(key: String) -> void:
	self.key = key
	_definition = tile_types[key]
	mesh = _definition.mesh
	#mesh.material.albedo_color = _definition.color_dark
	if icon:
		icon.texture = _definition.icon_texture
		icon.modulate = _definition.icon_color

func is_walkable() -> bool:
	return _definition.is_walkable

func is_transparent() -> bool:
	return _definition.is_transparent

#Selection
signal input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3)
signal mouse_entered()
signal mouse_exited()

var mouse_over := false
var image : Image

@onready var collision_shape := $Area3D/CollisionShape3D

var _mouse_input_received := false

func _ready():
	# Duplicate collision shape so it's unique
	collision_shape.shape = collision_shape.shape.duplicate()
	collision_shape.shape.size.y = _definition.hitbox_height

	await get_tree().physics_frame
	# Connect camera signal
	var camera = get_viewport().get_camera_3d()

	if camera.has_signal("mouse_ray_processed"):
		camera.mouse_ray_processed.connect(_on_3d_mouse_ray_processed)
	
	if _definition:
		icon.texture = _definition.icon_texture
		icon.modulate = _definition.icon_color

func _on_3d_mouse_ray_processed() -> void:
	# Received Input
	if _mouse_input_received:
		# Mouse Entered Case
		if !mouse_over:
			mouse_over = true
			mouse_entered.emit()
	
	# Mouse Exited Case
	elif mouse_over:
		mouse_over = false
		mouse_exited.emit()
	
	_mouse_input_received = false

func _on_mouse_entered():
	SignalBus.target_entered.emit(self.grid_position)

func _on_mouse_exited():
	SignalBus.target_exited.emit(self.grid_position)

func highlight(selection_color):
	_definition.selection_material.albedo_color = selection_color
	set_surface_override_material(0, _definition.selection_material if is_in_view else _definition.darkness_material)

func remove_highlight():
	set_surface_override_material(0, null if is_in_view else _definition.darkness_material)
	
# Takes the variables of the standard input_event signal
func try_mouse_input(camera: Node, event: InputEvent, input_position: Vector3, normal: Vector3) -> bool:
	_mouse_input_received = true
	input_event.emit(camera, event, input_position, normal)
	return true

func click_event(_camera: Node, event: InputEvent, _input_position: Vector3, _normal: Vector3) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		SignalBus.target_clicked.emit(grid_position, event.button_index)

#Save & Load
func get_save_data() -> Dictionary:
	return {
		"key": key,
		"is_explored": is_explored
	}

func restore(save_data: Dictionary) -> void:
	set_tile_type(save_data["key"])
	is_explored = save_data["is_explored"]
