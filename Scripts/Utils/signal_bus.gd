extends Node

signal player_died
signal player_descended
signal player_turned(angle, tween_rotation)

signal target_entered(grid_position)
signal target_exited(grid_position)
signal target_clicked(grid_position, button)

signal target_entity(entity)
signal untarget

signal message_sent(text, color)
signal escape_requested

signal lock_action(length)
