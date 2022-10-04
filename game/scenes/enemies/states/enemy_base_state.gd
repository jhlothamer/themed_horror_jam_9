class_name EnemeyBaseState
extends State

var enemy: Enemy

func init(_state_machine, _host) -> void:
	.init(_state_machine, _host)
	enemy = _host

