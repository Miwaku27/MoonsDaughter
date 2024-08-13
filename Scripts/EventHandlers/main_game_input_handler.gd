extends BaseInputHandler

const movements = [Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT]
const directions = [
	Vector2i.UP,
	Vector2i.UP + Vector2i.LEFT,
	Vector2i.LEFT,
	Vector2i.DOWN + Vector2i.LEFT,
	Vector2i.DOWN,
	Vector2i.DOWN + Vector2i.RIGHT,
	Vector2i.RIGHT,
	Vector2i.UP + Vector2i.RIGHT,
]

const inventory_menu_scene = preload("res://Scenes/GUI/inventory_menu.tscn")

@export var ability_input_manager: BaseInputHandler

func get_action(player : Entity) -> Action:
	var action: Action = null
	
	if Input.is_action_pressed("up"):
		var i = 0 + player.facing_direction * 2
		action = BumpAction.new(player, directions[i%8])
	elif Input.is_action_pressed("down"):
		var i = 4 + player.facing_direction * 2
		action = BumpAction.new(player, directions[i%8])
	elif Input.is_action_pressed("strafe_left"):
		var i = 2 + player.facing_direction * 2
		action = BumpAction.new(player, directions[i%8])
	elif Input.is_action_pressed("strafe_right"):
		var i = 6 + player.facing_direction * 2
		action = BumpAction.new(player, directions[i%8])
	elif Input.is_action_pressed("up_left"):
		var i = 1 + player.facing_direction * 2
		action = BumpAction.new(player, directions[i%8])
	elif Input.is_action_pressed("up_right"):
		var i = 7 + player.facing_direction * 2
		action = BumpAction.new(player, directions[i%8])
		
	elif Input.is_action_pressed("left"):
		action = TurnAction.new(player, 1)
	elif Input.is_action_pressed("right"):
		action = TurnAction.new(player, -1)
	elif Input.is_action_pressed("turn_back"):
		action = TurnAction.new(player, 2)
	
	if Input.is_action_just_pressed("wait"):
		action = WaitAction.new(player)
	
	if Input.is_action_just_pressed("pickup"):
		action = PickupAction.new(player)
	if Input.is_action_just_pressed("drop"):
		var selected_item: Entity = await get_item("Select an item to drop", player.inventory_component)
		action = DropItemAction.new(player, selected_item)
	if Input.is_action_just_pressed("inventory"):
		var selected_item: Entity = await get_item("Select an item to use", player.inventory_component)
		action = ItemAction.new(player, selected_item)
	
	if Input.is_action_just_pressed("view_history"):
		get_parent().transition_to(InputHandler.InputHandlers.HISTORY_VIEWER)
	
	
	if Input.is_action_just_pressed("quit") or Input.is_action_just_pressed("cancel"):
		action = EscapeAction.new(player)
	
	if action:
		return action
	else:
		return ability_input_manager.get_action(player)

func get_item(window_title: String, inventory: InventoryComponent) -> Entity:
	if inventory.items.is_empty():
		await get_tree().physics_frame
		MessageLog.send_message("No items in inventory.", GameColors.IMPOSSIBLE)
		return null
	var inventory_menu: InventoryMenu = inventory_menu_scene.instantiate()
	add_child(inventory_menu)
	inventory_menu.build(window_title, inventory)
	get_parent().transition_to(InputHandler.InputHandlers.DUMMY)
	var selected_item: Entity = await inventory_menu.item_selected
	await get_tree().physics_frame
	get_parent().call_deferred("transition_to", InputHandler.InputHandlers.MAIN_GAME)
	return selected_item
