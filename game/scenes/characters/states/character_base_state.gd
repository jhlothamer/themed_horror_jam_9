class_name CharacterBaseState
extends State

const BBDATA_TARGET_INTERACTION_HELPER = "interaction_helper"
const BBDATA_TARGET_ENEMY = "target_enemy"
const BBDATA_TARGET_POSITION = "target_position"

var character: Character

func init(_state_machine, _host) -> void:
	.init(_state_machine, _host)
	character = _host


func _add_hud_message(msg: String) -> void:
	var hud: HUD = ServiceMgr.get_service(HUD)
	if !hud:
		return
	hud.add_message(msg)


func _v_to_char_y(v: Vector3) -> Vector3:
	return Vector3(v.x, host.global_transform.origin.y, v.z)


func _calc_target_pos_for_object(clicked_object: CollisionObject) -> Vector3:
	var target_pos = _v_to_char_y(clicked_object.global_transform.origin)
	var temp = Rect2Util.clamp_point(GameConsts.CHARACTER_MOVE_BOUNDS, Vector2(target_pos.x, target_pos.z))
	target_pos.x = temp.x
	target_pos.z = temp.y
	var nav_pt_mgr: NavigationPointMgr = ServiceMgr.get_service(NavigationPointMgr)
	if nav_pt_mgr:
		var closest_pt = nav_pt_mgr.get_closest_navigation_point(character, clicked_object)
		if closest_pt != Vector3.INF:
			target_pos = _v_to_char_y(closest_pt)
	return target_pos
