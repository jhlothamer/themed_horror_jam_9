extends "res://scenes/enemies/states/enemy_base_state.gd"

export var character_position_refresh_time := 2.0


var _character_mgr: CharacterMgr
var _target_character: Character
var _refresh_timer := .0

var _target_pos: Vector3
var _path := []
var _path_index := 0

func _ready():
	_character_mgr = ServiceMgr.get_service(CharacterMgr)


func _recalc_char_target() -> void:
	if !_character_mgr:
		return
	_target_character = _character_mgr.get_closest_character(enemy.global_transform.origin)
	if !_target_character:
		_path = []
		_path_index = 0
		return
	_target_pos = _target_character.global_transform.origin

	var map_id = host.get_world().get_navigation_map()

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


func enter() -> void:
	if !_character_mgr or enemy.disabled:
		return
	_recalc_char_target()


func physics_process(delta):
	_refresh_timer += delta
	if _refresh_timer > character_position_refresh_time and !enemy.disabled:
		_recalc_char_target()
		_refresh_timer = 0.0
		return


	if _path_index >= _path.size():
		return
	
	var v = _path[_path_index] - enemy.global_transform.origin
	
	if !enemy.global_transform.origin.is_equal_approx(_path[_path_index]):
		enemy.look_at(_path[_path_index], Vector3.UP)
	
	var lin_vel = v.normalized() * enemy.horizontal_speed
	var frame_move_v = lin_vel * delta
	if v.length() <= frame_move_v.length():
		_path_index += 1
		if _path_index >= _path.size():
			_path = []
			_path_index = 0
	
	var _c = enemy.move_and_collide(frame_move_v)
	


