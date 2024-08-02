extends Camera3D

const RAY_LENGTH = 1000.0
const pan_angle = 40

signal mouse_ray_processed()

@export var mouse_sensitivity: float = 0.001
@export_flags_3d_physics var _sprite_layers

var _query_mouse := false
var _mouse_event : InputEventMouse


func _input(event):
	# Take all unhandled mouse events and save them to be processed	
	if event is InputEventMouse:
		rotate_camera(event)
		_query_mouse = true
		_mouse_event = event

func rotate_camera(event):
	var y = (event.position.x / get_viewport().size.x - .5) * pan_angle
	rotation.y = deg_to_rad(-y)
	var x = (event.position.y / get_viewport().size.y - .5) * pan_angle
	rotation.x = deg_to_rad(-x)

func _physics_process(_delta):
	if _query_mouse:
		_check_sprite_input()
		_query_mouse = false
		mouse_ray_processed.emit()

func _check_sprite_input() -> bool:
	# List of unsuccessful Sprite3Ds
	var not_hits = []

	# Construct raycast parameters
	var space_state = get_world_3d().direct_space_state
	var from = project_ray_origin(_mouse_event.position)
	var to = from + project_ray_normal(_mouse_event.position) * RAY_LENGTH
	
	# Iterate until successful hit or no valid sprites remain
	while true:
		var query = PhysicsRayQueryParameters3D.create(from, to, _sprite_layers, not_hits)
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)

		# Exit if no results
		if result.is_empty():
			return false

		# Exit if successful collision
		elif result.collider.owner.try_mouse_input(self, _mouse_event, result.position, result.normal):
			return true
		
		# Add sprite to not hits

		else:
			not_hits.append(result.collider)
	
	return true
