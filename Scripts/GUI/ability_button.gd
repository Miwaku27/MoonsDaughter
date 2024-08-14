extends TextureButton

@export var id: int

@onready var key_label = $KeyLabel
@onready var name_label = $NameLabel

var ability: AbilityDefinition

func _ready():
	SignalBus.ability_set.connect(set_ability)
	
	var input = InputMap.action_get_events(str(id))[0]
	key_label.text = input.as_text_physical_keycode()
	
	if %AbilityInputManager and %AbilityInputManager.player_abilities[id]:
		name_label.text = %AbilityInputManager.player_abilities[id].name
	else:
		name_label.text = "-"

func set_ability(_ability, slot):
	if slot == id:
		ability = _ability
		if ability:
			name_label.text = ability.name
		else:
			name_label.text = "-"


func _on_pressed():
	pass # Replace with function body.
