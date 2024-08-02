extends Node

signal player_died
signal player_descended
signal player_turned(angle, tween_rotation)

signal target_entered(grid_position, color)
signal target_exited(grid_position)
signal target_clicked(target, button)

signal message_sent(text, color)
signal escape_requested

signal lock_action(length)
