class_name EnemyWaveMgr

extends Node


export var disabled := false
export var delay_between_spawns_min := 3.0
export var delay_between_spawns_max := 10.0


func _spawn_wave(enemy_count: int) -> void:
	if disabled:
		return
	var spawn_mgr:EnemySpawnMgr = ServiceMgr.get_service(EnemySpawnMgr)
	for i in enemy_count:
		spawn_mgr.spawn_enemy()
		yield(get_tree().create_timer(rand_range(delay_between_spawns_min, delay_between_spawns_max)), "timeout")
