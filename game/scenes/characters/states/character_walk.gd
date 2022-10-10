extends CharacterBaseState

export var navigation_agent: NodePath
export var deny_interaction_sound: NodePath

onready var _deny_interaction_sound: AudioStreamPlayer3D = get_node_or_null(deny_interaction_sound)

var _nav_agent:NavigationAgent

var _target_pos: Vector3
var _target_interactable_object: CollisionObject
var _interaction_helper: InteractionHelper
var _move_to_indicator: Spatial


func _ready():
	_nav_agent = get_node(navigation_agent)
	SignalMgr.register_subscriber(self, "no_interactable_clicked")
	SignalMgr.register_subscriber(self, "interactable_clicked")
	if OK != _nav_agent.connect("navigation_finished", self, "_on_navigation_finished"):
		printerr("CharacterBase:Walk - cannot connect to NavigationAgent.navigation_finished")
	if OK != _nav_agent.connect("target_reached", self, "_on_target_reached"):
		printerr("CharacterBase:Walk - cannot connect to NavigationAgent.target_reached")


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
	_target_interactable_object = null
	_interaction_helper = null
	_calc_target_pos(pos)
	_create_move_to_indicator(pos)
	change_state(name)


func _on_interactable_clicked(helper: InteractionHelper, clicked_object: CollisionObject):
	if !character.is_selected():
		return

	if helper.interactable_type != "":
		if !character.allowed_interactable_types.has(helper.interactable_type):
			if _deny_interaction_sound and !_deny_interaction_sound.is_playing():
				_deny_interaction_sound.play()
			return

	if helper.required_resource_type != "":
		if !character.has_required_resource_amount(helper.required_resource_type, helper.required_resource_amount):
			if _deny_interaction_sound and !_deny_interaction_sound.is_playing():
				_deny_interaction_sound.play()
			return

	_calc_target_pos(clicked_object.global_transform.origin)
	_target_interactable_object = clicked_object
	_interaction_helper = helper
	_destroy_move_to_indicator()
	change_state(name)


func _calc_target_pos(pos: Vector3) -> void:
	_target_pos = _v_to_char_y(pos)
	_nav_agent.set_target_location(pos)


func _v_to_char_y(v: Vector3) -> Vector3:
	return Vector3(v.x, host.global_transform.origin.y, v.z)


func _on_navigation_finished():
	if !is_current_state():
		return
	_destroy_move_to_indicator()
	if _interaction_helper:
		set_blackboard_data(CharacterBaseState.BBDATA_TARGET_INTERACTION_HELPER, _interaction_helper)
		change_state("Interact")
		_interaction_helper = null
		return
	change_state("Idle")


func _on_target_reached():
	if !is_current_state():
		return
	_destroy_move_to_indicator()
	if _interaction_helper:
		change_state("Interact")
		_interaction_helper = null
		return
	change_state("Idle")



func physics_process(_delta: float) -> void:
	var next_location := _v_to_char_y(_nav_agent.get_next_location())
	if next_location == character.global_transform.origin:
		return
	
	var direction:Vector3 = character.global_transform.origin.direction_to(next_location)
	character.look_at(next_location, Vector3.UP)
	
	var linear_velocity = direction * character.horizontal_speed
	var _discard = character.move_and_slide(linear_velocity, Vector3.UP)
	



