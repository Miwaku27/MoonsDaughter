class_name ConsumeAction extends Action

var item: Entity


@warning_ignore("shadowed_variable")
func _init(entity: Entity, _item: Entity) -> void:
	super._init(entity)
	item = _item

func perform() -> bool:
	SignalBus.use_item.emit(item)
	return false
