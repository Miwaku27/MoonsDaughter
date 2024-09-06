extends BaseInputHandler

@export var map: Map

var player_abilities: Array[AbilityDefinition] = [null, null, null, null, null, null, null, null, null, null]
var current_ability: AbilityDefinition = null
@onready var player = %Player

var current_tile = null
var selected_tiles = []

func _ready():
	set_ability(Database.abilities["attack"], 0)
	set_ability(Database.abilities["faraway"], 1)
	set_ability(Database.abilities["aoe"], 2)
	SignalBus.target_entered.connect(target_entered)

func target_entered(grid_position):
	current_tile = map.get_tile(grid_position)
	if current_ability and current_ability.max_range > 0:
		highlight(grid_position, current_ability.zone)

func set_ability(ability: AbilityDefinition, slot: int):
	if slot >= 0 and slot < 10:
		player_abilities[slot] = ability
		SignalBus.ability_set.emit(ability, str(slot))
	else:
		MessageLog.send_message("No ability slot %s" % slot, GameColors.IMPOSSIBLE)

func get_action(_player : Entity) -> Action:
	if Input.is_action_just_pressed("click"):
		return start_ability()
	elif Input.is_action_just_pressed("unselect"):
		unselect_ability()
	elif Input.is_action_just_pressed("0"):
		select_ability(0)
	elif Input.is_action_just_pressed("1"):
		select_ability(1)
	elif Input.is_action_just_pressed("2"):
		select_ability(2)
	elif Input.is_action_just_pressed("3"):
		select_ability(3)
	elif Input.is_action_just_pressed("4"):
		select_ability(4)
	elif Input.is_action_just_pressed("5"):
		select_ability(5)
	elif Input.is_action_just_pressed("6"):
		select_ability(6)
	elif Input.is_action_just_pressed("7"):
		select_ability(7)
	elif Input.is_action_just_pressed("8"):
		select_ability(8)
	elif Input.is_action_just_pressed("9"):
		select_ability(9)
	
	return null

func select_ability(i: int) -> Action:
	if player_abilities.size() > i:
		var abi = player_abilities[i]
		
		if current_ability and abi and abi.id == current_ability.id:
			return start_ability()
		else:
			unselect_ability()
			current_ability = abi
	return null

func unselect_ability():
	current_ability = null
	if selected_tiles:
		remove_highlight()

func start_ability() -> Action:
	if not current_ability:
		return null
	
	var grid_position = current_tile.grid_position
	if player.distance(grid_position) > current_ability.max_range:
		MessageLog.send_message("The target is too far.", GameColors.IMPOSSIBLE)
		return null
	
	var action = AbilityAction.new(player, current_ability, selected_tiles, grid_position, map)
	unselect_ability()
	return action

func highlight(grid_position, radius):
	remove_highlight()
	add_tiles(grid_position, radius, selected_tiles)
	var color
	if current_ability.max_range <= 0:
		color = Color.PALE_TURQUOISE
	if player.distance(grid_position) <= current_ability.max_range:
		color = Color.PALE_GREEN
	else:
		color = Color.PALE_VIOLET_RED
	var entity
	for tile in selected_tiles:
		tile.highlight(color)
		entity = map.get_entity(tile.grid_position)
		if entity:
			entity.highlight(color)

func remove_highlight():
	var entity
	for tile in selected_tiles:
		tile.remove_highlight()
		entity = map.get_entity(tile.grid_position)
		if entity:
			entity.remove_highlight()
	selected_tiles = []

func add_tiles(grid_position, radius, tiles, n = true, w = true, s = true, e = true):
	if radius <= 0:
		return
	var tile = map.get_tile(grid_position)
	if tile:
		if not tiles.has(tile):
			tiles.append(tile)
		if tile.is_walkable:
			if n:
				add_tiles(Vector2i(grid_position.x+1, grid_position.y), radius - 1, tiles, n, w, false, e)
			if s:
				add_tiles(Vector2i(grid_position.x-1, grid_position.y), radius - 1, tiles, false, w, s, e)
			if e:
				add_tiles(Vector2i(grid_position.x, grid_position.y+1), radius - 1, tiles, n, false, s, e)
			if w:
				add_tiles(Vector2i(grid_position.x, grid_position.y-1), radius - 1, tiles, n, w, s, false)
