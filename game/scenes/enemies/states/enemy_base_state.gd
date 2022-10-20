class_name EnemeyBaseState
extends State

const BBDATA_TARGET_ATTACK_LIMIT = "attack_limit"
const BBDATA_TARGET_ATTACK_LIMIT_NEXT_STATE = "attack_limit_next_state"


var enemy: Enemy

func init(_state_machine, _host) -> void:
	.init(_state_machine, _host)
	enemy = _host



func _equal_nav_points(v1: Vector3, v2: Vector3) -> bool:
	return is_equal_approx(v1.x, v2.x) and is_equal_approx(v1.z, v2.z)
