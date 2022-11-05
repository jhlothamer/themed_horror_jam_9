extends CharacterBaseState

export var navigation_agent: NodePath
export var enemy_position_refresh_time := 1.0
#export var enemy_position_change_min := .25


var _nav_agent:NavigationAgent
var _target_pos: Vector3
var _target_enemy: Enemy
var _refresh_timer := .0



func _ready():
	_nav_agent = get_node(navigation_agent)
	if OK != _nav_agent.connect("navigation_finished", self, "_on_navigation_finished"):
		printerr("CharacterBase:%s - cannot connect to NavigationAgent.navigation_finished" % name)


func _calc_target_pos(pos: Vector3) -> void:
	_target_pos = _v_to_char_y(pos)
	var temp = Rect2Util.clamp_point(GameConsts.CHARACTER_MOVE_BOUNDS, Vector2(_target_pos.x, _target_pos.z))
	_target_pos.x = temp.x
	_target_pos.z = temp.y
	_nav_agent.set_target_location(_target_pos)


func _calc_target_pos_object(clicked_object: CollisionObject) -> void:
	_target_pos = _v_to_char_y(clicked_object.global_transform.origin)
	var temp = Rect2Util.clamp_point(GameConsts.CHARACTER_MOVE_BOUNDS, Vector2(_target_pos.x, _target_pos.z))
	_target_pos.x = temp.x
	_target_pos.z = temp.y
	var nav_pt_mgr: NavigationPointMgr = ServiceMgr.get_service(NavigationPointMgr)
	if nav_pt_mgr:
		var closest_pt = nav_pt_mgr.get_closest_navigation_point(character, clicked_object)
		if closest_pt != Vector3.INF:
			_target_pos = _v_to_char_y(closest_pt)
	_nav_agent.set_target_location(_target_pos)


func _on_navigation_finished():
	if !is_current_state():
		return
	if character.debug_movement:
		print("%s: navigation finished" % character.name)
	pop_state()


func enter() -> void:
	_target_enemy = get_blackboard_data(CharacterBaseState.BBDATA_TARGET_ENEMY)
	if _target_enemy != null:
		_calc_target_pos_object(_target_enemy)
		return
	_target_pos = get_blackboard_data(CharacterBaseState.BBDATA_TARGET_POSITION)
	if !_target_pos or _target_pos == Vector3.INF:
		printerr("%s: no target position or enemy!!" % get_path())
		return
	_calc_target_pos(_target_pos)


func exit():
	_target_enemy = null


func physics_process(delta: float) -> void:
	if _target_enemy:
		if !is_instance_valid(_target_enemy) or _target_enemy.is_dead():
			change_state("Idle")
			return
		_refresh_timer += delta

		if _refresh_timer > enemy_position_refresh_time:
			_calc_target_pos_object(_target_enemy)
			_refresh_timer = 0.0

	var next_location := _v_to_char_y(_nav_agent.get_next_location())
	if next_location == character.global_transform.origin or !is_current_state():
		if character.debug_movement:
			if next_location == character.global_transform.origin:
				print("%s: not moving - next location is character's position" % character.name)
			if !is_current_state():
				print("%s: not moving - %s state no longer current" % [character.name, name])

		return
	
	var direction:Vector3 = character.global_transform.origin.direction_to(next_location)
	character.look_at(next_location, Vector3.UP)
	
	var linear_velocity = direction * character.horizontal_speed
	var _discard = character.move_and_slide(linear_velocity, Vector3.UP)
	for i in character.get_slide_count():
		var kc := character.get_slide_collision(i)
		if kc.collider is Character:
			character.add_collision_exception_with(kc.collider)
		elif kc.collider == _target_enemy:
			pop_state()
	


func _on_enemy_exit_tree() -> void:
	pop_state()
