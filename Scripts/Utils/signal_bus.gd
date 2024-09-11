extends Node

signal player_died
signal player_descended
signal player_turned(angle, tween_rotation)

signal ability_set(ability, slot)

signal target_entered(grid_position)
signal target_exited(grid_position)
signal target_clicked(grid_position, button)

signal target_entity(entity)
signal untarget

signal message_sent(text, color)
signal game_menu_requested

signal lock_action(length)

signal use_item(item)
