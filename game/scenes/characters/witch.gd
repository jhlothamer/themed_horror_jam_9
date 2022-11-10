class_name Witch
extends Character


export var crystal_ball_ward_mana_cost := 50


onready var _animation_player: AnimationPlayer = $WitchAnimations_Frank_Ilikethepixies/AnimationPlayer
onready var _deny_interaction_sound: AudioStreamPlayer = $DenyInteractionSound

var _interactable_object_name: String
var _state_animations := {
	"Idle": "Idle",
	"Shoot": "Shoot Magic",
	"WalkTo": "Walking",
}
var _looping_animations := [
	"Idle",
	"Walking",
	"Cauldron",
	"Crystal Ball",
	"Manapool",
	"Spellbook",
	"Shoot Magic"
]
var _interact_state_animations_for_object := {
	"Cauldron": "Cauldron",
	"ManaPool": "Manapool",
	"CrystalBall": "Crystal Ball",
	"Spellbook": "Spellbook",
}


func _on_StateMachine_state_changed(old_state, new_state):
	._on_StateMachine_state_changed(old_state, new_state)
	if new_state == "Interact":
		_interactable_object_name = _interact_state.get_interactable_object_name()
		if _interact_state_animations_for_object.has(_interactable_object_name):
			_animation_player.play(_interact_state_animations_for_object[_interactable_object_name])
	else:
		_interactable_object_name = ""
	if _state_animations.has(new_state):
		_animation_player.play(_state_animations[new_state])



func _on_AnimationPlayer_animation_finished(anim_name):
	if _looping_animations.has(anim_name):
		_animation_player.play(anim_name)


func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("place_ward") \
	or _interactable_object_name != "CrystalBall":
		return

	if !has_required_resource_amount(GameConsts.RESOURCE_MANA, crystal_ball_ward_mana_cost):
		if !_deny_interaction_sound.is_playing():
			_deny_interaction_sound.play()
		_add_hud_message("Not enough mana to place ward.  Get more from mana pool.")
		return
	
	var ward_mgr: WardMgr = ServiceMgr.get_service(WardMgr)
	if !ward_mgr:
		printerr("Witch: can't get WardMgr service!!")
		return
	
	if ward_mgr.disabled:
		if !_deny_interaction_sound.is_playing():
			_deny_interaction_sound.play()
		return
	
	if !ward_mgr.place_ward():
		if !_deny_interaction_sound.is_playing():
			_deny_interaction_sound.play()
		_add_hud_message("Only one ward can be placed at a time.")
		return
	
	decrease_resource_amount(GameConsts.RESOURCE_MANA, crystal_ball_ward_mana_cost)

