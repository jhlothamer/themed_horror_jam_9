class_name EnemyWaveMgr
extends Node

export var delay_between_enemy_spawns := 1.0

var _enemy_spawn_counter := 1
var _enemy_increase_amount := 0.0


func _on_Timer_timeout():
	_spawn_wave()

func _spawn_wave() -> void:
	var spawn_mgr:EnemySpawnMgr = ServiceMgr.get_service(EnemySpawnMgr)
	for i in _enemy_spawn_counter:
		spawn_mgr.spawn_enemy()
		yield(get_tree().create_timer(delay_between_enemy_spawns), "timeout")
	_enemy_increase_amount += .5
	_enemy_spawn_counter += int(floor(_enemy_increase_amount))
