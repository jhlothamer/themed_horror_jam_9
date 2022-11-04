extends CharacterBaseState


export var deny_interaction_sound: NodePath


onready var _deny_interaction_sound: AudioStreamPlayer = get_node_or_null(deny_interaction_sound)

var _interaction_helper: InteractionHelper
var _target_interactable_object: CollisionObject


func _ready():
	SignalMgr.register_subscriber(self, "interaction_completed")
	SignalMgr.register_subscriber(self, "interactable_clicked")


func _on_interactable_clicked(helper: InteractionHelper, clicked_object: CollisionObject):
	if !character.is_selected():
		return

	if helper.interactable_type != "":
		if !character.allowed_interactable_types.has(helper.interactable_type):
			if _deny_interaction_sound and !_deny_interaction_sound.is_playing():
				_deny_interaction_sound.play()
			if helper.allowed_type_deny_message != "":
				_add_hud_message(helper.allowed_type_deny_message)
			return

	if clicked_object and clicked_object.has_method("can_interact"):
		if !clicked_object.can_interact(character):
			if _deny_interaction_sound and !_deny_interaction_sound.is_playing():
				_deny_interaction_sound.play()
			if clicked_object.has_method("get_deny_message"):
				var deny_message: String = clicked_object.get_deny_message(character)
				if deny_message != "":
					_add_hud_message(deny_message)
			return

	if helper.required_resource_type != "":
		if !character.has_required_resource_amount(helper.required_resource_type, helper.required_resource_amount):
			if _deny_interaction_sound and !_deny_interaction_sound.is_playing():
				_deny_interaction_sound.play()
			if helper.required_resource_deny_message != "":
				_add_hud_message(helper.required_resource_deny_message)
			return
	if is_current_state() and _interaction_helper:
		_interaction_helper.stop_interaction(character)
		_interaction_helper = null
	_target_interactable_object = clicked_object
	change_state(name)
	_interaction_helper = helper


func get_interactable_object_name() -> String:
	return _target_interactable_object.name


func enter() -> void:
	set_blackboard_data(CharacterBaseState.BBDATA_TARGET_POSITION, _calc_target_pos_for_object(_target_interactable_object))
	push_state("WalkTo")


func reenter(_from_state: String) -> void:
	var lookat_v = _target_interactable_object.global_transform.origin
	lookat_v.y = character.global_transform.origin.y
	character.look_at(lookat_v, Vector3.UP)
	_interaction_helper.start_interaction(character)


func exit() -> void:
	if _interaction_helper:
		_interaction_helper.stop_interaction(character)
		_interaction_helper = null


func _on_interaction_completed(helper: InteractionHelper, _clicked_object: CollisionObject, interactor):
	if helper != _interaction_helper:
		return
	if interactor and interactor != character:
		return
	_interaction_helper = null
	change_state("Idle")
