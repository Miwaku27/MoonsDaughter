class_name Player extends Entity

var facing_direction: int

func turn_towards(dir : int):
	facing_direction += dir
	
	if facing_direction < 0:
		facing_direction += 4
	elif facing_direction > 3:
		facing_direction -= 4
	
	var angle = deg_to_rad(90 * facing_direction)
	angle = lerp_angle(rotation.y, angle, 1)
	SignalBus.player_turned.emit(angle, dir != 0)

func get_save_data() -> Dictionary:
	var save_data: Dictionary = super()
	save_data["facing_direction"] = facing_direction
	return save_data
	
func restore(save_data: Dictionary) -> void:
	super(save_data)
	facing_direction = save_data["facing_direction"]
