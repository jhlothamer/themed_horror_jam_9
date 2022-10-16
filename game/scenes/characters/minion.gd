extends Character


onready var _animation_player:AnimationPlayer = $goblinanimations_frank_ilikethepixes/AnimationPlayer

var _state_animations := {
	"Idle": "Idle",
	"Walk": "Walking",
	"Shoot": "Shoot",
}

var _looping_animations := [
	"Idle",
	"Walking",
	"Cauldron",
	"Crystal Ball",
	"Manapool",
	"Spellbook",
	"Repair",
	"Gather Wood",
]

var _interactable_object_name := ""

var _interact_state_animations_for_object := {
	"Cauldron": "Cauldron",
	"ManaPool": "Manapool",
	"CrystalBall": "Idle", #"Crystal Ball",
	"Spellbook": "Spellbook",
	"Destructable": "Repair",
	"WoodPile": "Gather Wood",
}


func _ready():
	SignalMgr.register_subscriber(self, "spell_activated")
	SignalMgr.register_subscriber(self, "spell_deactivated")


func _on_spell_activated():
	can_shoot = true
	if !allowed_interactable_types.has(GameConsts.INTERACTABLE_TYPE_MANA_POOL):
		allowed_interactable_types.append(GameConsts.INTERACTABLE_TYPE_MANA_POOL)


func _on_spell_deactivated():
	can_shoot = false
	allowed_interactable_types.erase(GameConsts.INTERACTABLE_TYPE_MANA_POOL)
	var _discard = resources.erase(GameConsts.RESOURCE_MANA)


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
	_interactable_object_name = interactable_object.name
	if _interactable_object_name.begins_with("Door") or _interactable_object_name.begins_with("Window"):
		_interactable_object_name = "Destructable"

