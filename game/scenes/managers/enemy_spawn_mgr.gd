class_name EnemySpawnMgr
extends Node


const SCENE_ENEMY = preload("res://scenes/enemies/zombie.tscn")


class DestructableData:
	var destructable:Destructable
	var direction: int
	func _init(destr: Destructable, dir: int):
		destructable = destr
		direction = dir


export (Array, NodePath) var north_spawn_positions := []
export (Array, NodePath) var south_spawn_positions := []
export (Array, NodePath) var west_spawn_positions := []
export (Array, NodePath) var east_spawn_positions := []

export (Array, NodePath) var north_destructables := []
export (Array, NodePath) var south_destructables := []
export (Array, NodePath) var west_destructables := []
export (Array, NodePath) var east_destructables := []
export var force_east_spawning := false

var _rand := RandomNumberGenerator.new()
var _spawn_positions_by_direction := {}
var _available_spawn_directions := []
var _destructables_by_direction := {}
var _destructable_data := []


func _enter_tree():
	ServiceMgr.register_service(get_script(), self)


func _ready():
	_rand.randomize()
	
	_add_node_list(_spawn_positions_by_direction, GameConsts.EnemySpawnDirection.NORTH, north_spawn_positions)
	_add_node_list(_spawn_positions_by_direction, GameConsts.EnemySpawnDirection.SOUTH, south_spawn_positions)
	_add_node_list(_spawn_positions_by_direction, GameConsts.EnemySpawnDirection.WEST, west_spawn_positions)
	_add_node_list(_spawn_positions_by_direction, GameConsts.EnemySpawnDirection.EAST, east_spawn_positions)
	_add_node_list(_destructables_by_direction, GameConsts.EnemySpawnDirection.NORTH, north_destructables)
	_add_node_list(_destructables_by_direction, GameConsts.EnemySpawnDirection.SOUTH, south_destructables)
	_add_node_list(_destructables_by_direction, GameConsts.EnemySpawnDirection.WEST, west_destructables)
	_add_node_list(_destructables_by_direction, GameConsts.EnemySpawnDirection.EAST, east_destructables)
	
	for direction in _destructables_by_direction.keys():
		for destructable in _destructables_by_direction[direction]:
			_destructable_data.append(DestructableData.new(destructable, direction))
	
	_available_spawn_directions = _spawn_positions_by_direction.keys()


func _add_node_list(d: Dictionary, key: int, node_paths: Array) -> void:
	var nodes = _get_nodes(node_paths)
	if !nodes:
		return
	d[key] = nodes


func _get_nodes(node_paths: Array) -> Array:
	var nodes := []
	for path in node_paths:
		var temp = get_node_or_null(path)
		if temp:
			nodes.append(temp)
	
	return nodes


func _spawn_enemy(agression_level: int, direction: int, spawn_position: Vector3, target_destructable: Destructable = null) -> void:
	spawn_position.y = 0.0
	var parent = get_node_or_null("%DynamicParent")
	if !parent:
		print("EnemySpawnMgr: couldn't get dynamic parent - using scene")
		parent = get_tree().current_scene
	var enemy = SCENE_ENEMY.instance()
	enemy.spawn_direction = direction
	enemy.agression_level = agression_level
	enemy.target_destructable = target_destructable
	parent.add_child(enemy)
	enemy.global_transform.origin = spawn_position


func spawn_enemy(agression_level: int = -1) -> void:
	if agression_level == GameConsts.EnemyAgressionLevel.MEDIUM:
		if _spawn_enemy_medium_agression():
			return
		agression_level = GameConsts.EnemyAgressionLevel.HIGH
	if agression_level < GameConsts.EnemyAgressionLevel.LOW:
		agression_level = GameConsts.EnemyAgressionLevel.HIGH
	
	var index: int = _rand.randi() % _available_spawn_directions.size()
	var direction = _available_spawn_directions[index]
	var spawn_positions:Array = _spawn_positions_by_direction[direction]
	index = _rand.randi() % spawn_positions.size()
	var spawn_position: Vector3 = spawn_positions[index].global_transform.origin
	_spawn_enemy(agression_level, direction, spawn_position)


func _spawn_enemy_medium_agression() -> bool:
	var valid_targets := []
	for i in _destructable_data:
		if i.destructable.is_dead():
			continue
		if force_east_spawning and i.direction != GameConsts.EnemySpawnDirection.EAST:
			continue
		valid_targets.append(i)
	
	if !valid_targets and force_east_spawning:
		print("EnemySpawnMgr: no more destructables valid from west - trying other directions")
		for i in _destructable_data:
			if i.destructable.is_dead():
				continue
			valid_targets.append(i)
	
	if !valid_targets:
		return false
	
	var index: int = _rand.randi() % valid_targets.size()
	var destructable_data: DestructableData = valid_targets[index]
	var spawn_positions:Array = _spawn_positions_by_direction[destructable_data.direction]
	index = _rand.randi() % spawn_positions.size()
	var spawn_position: Vector3 = spawn_positions[index].global_transform.origin
	_spawn_enemy(GameConsts.EnemyAgressionLevel.MEDIUM, destructable_data.direction, spawn_position, destructable_data.destructable)
	
	
	return true

