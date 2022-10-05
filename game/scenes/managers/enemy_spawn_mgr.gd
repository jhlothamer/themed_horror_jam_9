class_name EnemySpawnMgr
extends Node


const SCENE_ENEMY = preload("res://scenes/enemies/enemy_base.tscn")

export (Array, NodePath) var spawn_positions := []


var _spawn_positions := []


func _enter_tree():
	ServiceMgr.register_service(get_script(), self)

func _ready():
	for i in spawn_positions:
		var spawn_position: Spatial = get_node(i)
		if spawn_position:
			_spawn_positions.append(spawn_position)
	
	if _spawn_positions.empty():
		printerr("EnemySpawnMgr: no spawn positions!  Can't spawn enemies.")


func spawn_enemy() -> void:
	if _spawn_positions.empty():
		return
	print("Spawning enemy")
	var index: int = randi() % _spawn_positions.size()
	var spawn_position: Vector3 = _spawn_positions[index].global_transform.origin
	spawn_position.y = 0.0
	var parent = get_node_or_null("%DynamicParent")
	if !parent:
		print("EnemySpawnMgr: couldn't get dynamic parent - using scene")
		parent = get_tree().current_scene
	var enemy = SCENE_ENEMY.instance()
	parent.add_child(enemy)
	enemy.global_transform.origin = spawn_position
