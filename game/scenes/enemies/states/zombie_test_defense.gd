extends EnemeyBaseState

var _target_pos: Vector3
var _path := []
var _path_index := 0


func _equal_nav_points(v1: Vector3, v2: Vector3) -> bool:
	return is_equal_approx(v1.x, v2.x) and is_equal_approx(v1.z, v2.z)


func enter() -> void:
	
	set_blackboard_data(EnemeyBaseState.BBDATA_TARGET_ATTACK_LIMIT, 2)
	set_blackboard_data(EnemeyBaseState.BBDATA_TARGET_ATTACK_LIMIT_NEXT_STATE, "Wander")

	_target_pos = enemy.target_destructable.global_transform.origin

	var map_id = host.get_world().get_navigation_map()

	_path = NavigationServer.map_get_path(map_id, enemy.global_transform.origin, _target_pos, true)
	# when path obtained too soon after startup it can be invalid.  Loop/wait till we have a good path.
	while _path.size() == 0 or !_equal_nav_points(_target_pos, _path.back()):
		_path = []
		yield(get_tree().create_timer(1.0), "timeout")
		_path = NavigationServer.map_get_path(map_id, enemy.global_transform.origin, _target_pos, true)

	_path_index = 0
	
	# ensure path is on the same plain as character
	var y = enemy.global_transform.origin.y
	for i in _path.size():
		_path[i].y = y
	
	#if path begins with character's position - remove it
	if _path.size() > 0 and enemy.global_transform.origin.is_equal_approx(_path.front()):
		_path.pop_front()
	
	#if path doesn't end with target position - add it
	if _path.size() > 0 and !_target_pos.is_equal_approx(_path.back()):
		_path.push_back(_target_pos)


func physics_process(delta):
	if _path_index >= _path.size():
		return
	
	var v = _path[_path_index] - enemy.global_transform.origin
	
	if !enemy.global_transform.origin.is_equal_approx(_path[_path_index]):
		enemy.look_at(_path[_path_index], Vector3.UP)
	
	var lin_vel = v.normalized() * enemy.horizontal_speed
	var frame_move_v = lin_vel * delta
	if v.length_squared() <= frame_move_v.length_squared():
		_path_index += 1
		if _path_index >= _path.size():
			_path = []
			_path_index = 0
	
	var _c = enemy.move_and_collide(frame_move_v)
