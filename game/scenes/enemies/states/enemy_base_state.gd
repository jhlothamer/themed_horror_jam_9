class_name EnemeyBaseState
extends State

const BBDATA_TARGET_ATTACK_LIMIT = "attack_limit"
const BBDATA_TARGET_ATTACK_LIMIT_NEXT_STATE = "attack_limit_next_state"


var enemy: Enemy

func init(_state_machine, _host) -> void:
	.init(_state_machine, _host)
	enemy = _host

