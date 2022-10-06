extends CanvasLayer

func _input(event):
	if event.is_action_pressed("spawn_zombie"):
		var enemy_spawn_mgr: EnemySpawnMgr = ServiceMgr.get_service(EnemySpawnMgr)
		if !enemy_spawn_mgr:
			print("TestHud: Could not get service EnemySpawnMgr")
			return
		enemy_spawn_mgr.spawn_enemy()
