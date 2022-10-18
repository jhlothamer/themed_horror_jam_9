class_name NavigationAreaMgr
extends Node


export var north_area: NodePath
export var south_area: NodePath
export var west_area: NodePath
export var east_area: NodePath


onready var _areas := {
	GameConsts.EnemySpawnDirection.NORTH: get_node_or_null(north_area),
	GameConsts.EnemySpawnDirection.SOUTH: get_node_or_null(south_area),
	GameConsts.EnemySpawnDirection.WEST: get_node_or_null(west_area),
	GameConsts.EnemySpawnDirection.EAST	: get_node_or_null(east_area),
}


func _enter_tree():
	ServiceMgr.register_service(get_script(), self, name)


func get_position_in_area(direction) -> Vector3:
	var area: RandPointPlane
	if _areas.has(direction):
		area = _areas[direction]
	
	if area:
		return area.get_random_point()
	
	return Vector3.INF
