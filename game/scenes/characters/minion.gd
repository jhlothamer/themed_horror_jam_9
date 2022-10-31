extends Character


onready var _animation_player:AnimationPlayer = $goblinanimations_frank_ilikethepixes/AnimationPlayer
onready var _spell_active_indicator = $SpellActiveIndicator
onready var _wood_icon = $WoodIcon


var _state_animations := {
	"Idle": "Idle",
	"Walk": "Walking",
	"Shoot": "Shoot",
}

var _looping_animations := [
	"Idle",
	"Walking",
	"Cauldron",
	"Manapool",
	"Spellbook",
	"Repair",
	"Gather Wood",
]

var _interactable_object_name := ""

var _interact_state_animations_for_object := {
	"Cauldron": "Cauldron",
	"ManaPool": "Manapool",
	"Spellbook": "Spellbook",
	"Destructable": "Repair",
	"WoodPile": "Gather Wood",
}


func _ready():
	SignalMgr.register_subscriber(self, "spell_activated")
	SignalMgr.register_subscriber(self, "spell_deactivated")


func _on_spell_activated():
	_spell_active_indicator.visible = true
	can_shoot = true
	if !allowed_interactable_types.has(GameConsts.INTERACTABLE_TYPE_MANA_POOL):
		allowed_interactable_types.append(GameConsts.INTERACTABLE_TYPE_MANA_POOL)


func _on_spell_deactivated():
	_spell_active_indicator.visible = false
	can_shoot = false
	allowed_interactable_types.erase(GameConsts.INTERACTABLE_TYPE_MANA_POOL)
	var _discard = resources.erase(GameConsts.RESOURCE_MANA)
	_mana_bar.visible = false
	_mana_bar.value = 0.0


func _on_StateMachine_state_changed(old_state, new_state):
	._on_StateMachine_state_changed(old_state, new_state)
	if new_state == "Interact":
		if _interact_state_animations_for_object.has(_interactable_object_name):
			_animation_player.play(_interact_state_animations_for_object[_interactable_object_name])
	if _state_animations.has(new_state):
		_animation_player.play(_state_animations[new_state])


func _on_AnimationPlayer_animation_finished(anim_name):
	if _looping_animations.has(anim_name):
		_animation_player.play(anim_name)


func _on_Walk_interaction_about_to_start(interactable_object: Node):
	if interactable_object is Destructable:
		_interactable_object_name = "Destructable"
	else:
		_interactable_object_name = interactable_object.name


func set_resource_amount(resource_name: String, resource_amount: int) -> void:
	.set_resource_amount(resource_name, resource_amount)
	_wood_icon.visible = has_required_resource_amount(GameConsts.RESOURCE_WOOD, 100)

func decrease_resource_amount(resource_name: String, resource_amount: int) -> void:
	.decrease_resource_amount(resource_name, resource_amount)
	_wood_icon.visible = has_required_resource_amount(GameConsts.RESOURCE_WOOD, 100)


