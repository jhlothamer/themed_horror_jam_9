extends EnemeyBaseState


var _path := []
var _path_index := 0


func enter():
	enemy._disable_collisions()
	
	var retreat_area_mgr: NavigationAreaMgr = ServiceMgr.get_service(NavigationAreaMgr, GameConsts.SERVICE_NAME_RETREAT_AREA_MGR)
	if !retreat_area_mgr:
		printerr("Enemey:Retreat: could not get %s service." % GameConsts.SERVICE_NAME_RETREAT_AREA_MGR)
		change_state("Die")
		return
	
	var target_pos = retreat_area_mgr.get_position_in_area(enemy.spawn_direction)
	
	var map_id = host.get_world().get_navigation_map()

	_path = NavigationServer.map_get_path(map_id, enemy.global_transform.origin, target_pos, true)
	if _path.size() == 0 or !_equal_nav_points(target_pos, _path.back()):
		change_state("Die")
		return
	_path_index = 0
	
	# ensure path is on the same plain as character
	var y = enemy.global_transform.origin.y
	for i in _path.size():
		_path[i].y = y
	
	#if path begins with character's position - remove it
	if _path.size() > 0 and enemy.global_transform.origin.is_equal_approx(_path.front()):
		_path.pop_front()
	
	#if path doesn't end with target position - add it
	if _path.size() > 0 and !target_pos.is_equal_approx(_path.back()):
		_path.push_back(target_pos)


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
			enemy.queue_free()
			_path = []
			_path_index = 0
	
	var _c = enemy.move_and_collide(frame_move_v)
