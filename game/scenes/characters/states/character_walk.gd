extends CharacterBaseState


var _move_to_indicator: Spatial


func _ready():
	SignalMgr.register_subscriber(self, "no_interactable_clicked")


func _create_move_to_indicator(pos: Vector3) -> void:
	if !is_instance_valid(_move_to_indicator):
		_move_to_indicator = GameConsts.SCENE_MOVE_TO_INDICATOR.instance()
		var parent: Spatial = GameUtil.get_dynamic_parent(character)
		parent.add_child(_move_to_indicator)
	_move_to_indicator.global_transform.origin = pos
	_move_to_indicator.animate()


func _destroy_move_to_indicator() -> void:
	if !_move_to_indicator:
		return
	_move_to_indicator.queue_free()
	_move_to_indicator = null


func _on_no_interactable_clicked(pos: Vector3) -> void:
	if !host.is_selected():
		return
	set_blackboard_data(CharacterBaseState.BBDATA_TARGET_POSITION, pos)
#	_calc_target_pos(pos)
	change_state(name)
	_create_move_to_indicator(_v_to_char_y(pos))


func enter() -> void:
	push_state("WalkTo")


func reenter(_from_state: String) -> void:
	change_state("Idle")


func exit() -> void:
	_destroy_move_to_indicator()

