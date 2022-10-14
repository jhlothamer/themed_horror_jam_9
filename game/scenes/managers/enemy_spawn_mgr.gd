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
	parent.add_child(enemy)
	enemy.global_transform.origin = spawn_position
