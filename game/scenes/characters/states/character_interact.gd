extends CharacterBaseState

var _interaction_helper: InteractionHelper


func _ready():
	SignalMgr.register_subscriber(self, "interaction_completed")


func enter() -> void:
	_interaction_helper = get_blackboard_data(CharacterBaseState.BBDATA_TARGET_INTERACTION_HELPER)
	_interaction_helper.start_interaction(character)


func exit() -> void:
	if _interaction_helper:
		_interaction_helper.stop_interaction(character)


func _on_interaction_completed(helper: InteractionHelper, _clicked_object: CollisionObject):
	if helper != _interaction_helper:
		return
	_interaction_helper = null
	change_state("Idle")
