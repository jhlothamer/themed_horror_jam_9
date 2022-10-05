extends CanvasLayer




func _on_SpawnZombieBtn_pressed():
	var enemy_spawn_mgr: EnemySpawnMgr = ServiceMgr.get_service(EnemySpawnMgr)
	if !enemy_spawn_mgr:
		print("TestHud: Could not get service EnemySpawnMgr")
		return
	enemy_spawn_mgr.spawn_enemy()
