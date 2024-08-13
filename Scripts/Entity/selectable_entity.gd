class_name SelectableEntity extends Entity

signal input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3)
signal mouse_entered()
signal mouse_exited()

var mouse_over := false
var image : Image

@onready var collision_shape := $Area3D/CollisionShape3D

var _mouse_input_received := false


func _ready():
	super._ready()
	# Duplicate collision shape so it's unique
	collision_shape.shape = collision_shape.shape.duplicate()

	# Update image and collision shape
	_on_texture_changed()
	
	await get_tree().physics_frame
	# Connect camera signal
	var camera = get_viewport().get_camera_3d()

	if camera.has_signal("mouse_ray_processed"):
		camera.mouse_ray_processed.connect(_on_3d_mouse_ray_processed)

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

func _on_texture_changed() -> void:	
	if collision_shape:
		if texture:
			# We call this only when the texture is changed to save on performance
			image = texture.get_image()
			
			# Call this to allow get_pixel later (thanks Godot 4.2)
			if image.is_compressed():
				image.decompress()
			
			# Update CollisionShape parameters
			collision_shape.shape.size.x = texture.get_width() * pixel_size
			collision_shape.shape.size.y = texture.get_height() * pixel_size
		else:
			collision_shape.shape.size.x = 0
			collision_shape.shape.size.y = 0

func _on_mouse_entered():
	SignalBus.target_entered.emit(self.grid_position)

func _on_mouse_exited():
	SignalBus.target_exited.emit(self.grid_position)

func highlight(selection_color):
	modulate = selection_color

func remove_highlight():
	modulate = mod_color

# Takes the variables of the standard input_event signal
func try_mouse_input(camera: Node, event: InputEvent, input_position: Vector3, normal: Vector3) -> bool:
	if is_pixel_opaque(input_position):
		_mouse_input_received = true
		input_event.emit(camera, event, input_position, normal)
		return true
	else:
		return false

func is_pixel_opaque(input_position: Vector3) -> bool:
	var inv_transform = global_transform.affine_inverse()
	var local_point = inv_transform * input_position

	var pixel_position = local_point / pixel_size

	var texture_local_x = pixel_position.x + (texture.get_width() / 2.0)
	var texture_local_y = texture.get_height() - (pixel_position.y + texture.get_height() / 2.0)

	return image.get_pixel(texture_local_x, texture_local_y).a > 0.0

func click_event(_camera: Node, event: InputEvent, _input_position: Vector3, _normal: Vector3) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		SignalBus.target_clicked.emit(grid_position, event.button_index)
