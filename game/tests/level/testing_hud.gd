extends CanvasLayer


onready var _ui: Container = $MarginContainer


var _disable := false


func _ready():
	var wave_mgr: EnemyWaveMgr = ServiceMgr.get_service(EnemyWaveMgr)
	if wave_mgr and !wave_mgr.disabled:
		_disable = true
		_ui.visible = false


func _input(event):
	if _disable:
		return
	if event.is_action_pressed("spawn_zombie"):
		var enemy_spawn_mgr: EnemySpawnMgr = ServiceMgr.get_service(EnemySpawnMgr)
		if !enemy_spawn_mgr:
			print("TestHud: Could not get service EnemySpawnMgr")
			return
		enemy_spawn_mgr.spawn_enemy()
