extends State


var _path := []
var _path_index := 0

func enter() -> void:
	var target_pos: Vector3 = host.get_random_point()
	if target_pos == Vector3.INF:
		change_state("Idle")
		return
	var map_id = host.get_world().get_navigation_map()
	_path = NavigationServer.map_get_path(map_id, host.global_transform.origin, target_pos, true, 2)
	var y = host.global_transform.origin.y
	for i in _path.size():
		_path[i].y = y
	_path_index = 0


func physics_process(delta) -> void:
	if _path_index >= _path.size():
		return
	if host.global_transform.origin != _path[_path_index]:
		host.look_at(_path[_path_index], Vector3.UP)
	
	var v = _path[_path_index] - host.global_transform.origin
	
	var lin_vel = v.normalized() * host.horizontal_speed
	var frame_move_v = lin_vel * delta
	if v.length() <= frame_move_v.length():
		_path_index += 1
		if _path_index >= _path.size():
			change_state("Idle")
			return
#	host.translate(frame_move_v)
	host.global_transform.origin += frame_move_v
