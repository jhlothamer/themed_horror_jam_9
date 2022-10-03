extends CharacterBaseState

var _interaction_helper: InteractionHelper


func enter() -> void:
	_interaction_helper = get_blackboard_data(CharacterBaseState.BBDATA_TARGET_INTERACTION_HELPER)
	_interaction_helper.start_interaction()

func exit() -> void:
	_interaction_helper.stop_interaction()

