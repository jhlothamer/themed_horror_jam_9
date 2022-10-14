class_name Witch
extends Character

onready var _animation_player: AnimationPlayer = $WitchAnimations_Frank_Ilikethepixies/AnimationPlayer


var _state_animations := {
	"Idle": "Idle",
	"Walk": "Walking",
	"Shoot": "Shoot Magic",
}

var _looping_animations := [
	"Idle",
	"Walking",
	"Cauldron",
	"Crystal Ball",
	"Manapool",
	"Spellbook",
]

var _interactable_object_name := ""

var _interact_state_animations_for_object := {
	"Cauldron": "Cauldron",
	"ManaPool": "Manapool",
	"CrystalBall": "Crystal Ball",
	"Spellbook": "Spellbook",
}

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

