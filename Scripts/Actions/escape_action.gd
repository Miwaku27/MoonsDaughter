class_name EscapeAction extends Action

func perform() -> bool:
	#entity.map_data.save()
	SignalBus.game_menu_requested.emit()
	return false
