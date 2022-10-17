class_name EnemySpawnMgr
extends Node


const SCENE_ENEMY = preload("res://scenes/enemies/zombie.tscn")

export var spawn_position_parent: NodePath


var _spawn_positions := []


func _enter_tree():
	ServiceMgr.register_service(get_script(), self)

func _ready():
	var position_parent = get_node(spawn_position_parent)
	if !position_parent:
		printerr("EnemySpawnMgr: Bad spawn position parent node path!  Can't spawn enemies.")
		return
	
	for i in position_parent.get_children():
		var spawn_position: Spatial = i
		if spawn_position:
			_spawn_positions.append(spawn_position)
	
	if _spawn_positions.empty():
		printerr("EnemySpawnMgr: no spawn positions!  Can't spawn enemies.")


func _get_spawn_direction(spawn_position: Spatial) -> int:
	for key in GameConsts.EnemySpawnDirection.keys():
		if spawn_position.name.to_upper().begins_with(key):
			return GameConsts.EnemySpawnDirection[key]
	
	printerr("EnemySpawnMgr: coult not determine spawn direction from %s" % spawn_position.get_path())
	return GameConsts.EnemySpawnDirection.UNKNOWN


func spawn_enemy() -> void:
	if _spawn_positions.empty():
		return
	
	var index: int = randi() % _spawn_positions.size()
	var spawn_position: Vector3 = _spawn_positions[index].global_transform.origin
	spawn_position.y = 0.0
	var parent = get_node_or_null("%DynamicParent")
	if !parent:
		print("EnemySpawnMgr: couldn't get dynamic parent - using scene")
		parent = get_tree().current_scene
	var enemy = SCENE_ENEMY.instance()
	enemy.spawn_direction = _get_spawn_direction(_spawn_positions[index])
	parent.add_child(enemy)
	enemy.global_transform.origin = spawn_position
