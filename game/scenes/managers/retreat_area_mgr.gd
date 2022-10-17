class_name RetreatAreaMgr
extends Node


export var north_retreat_area: NodePath
export var south_retreat_area: NodePath
export var west_retreat_area: NodePath
export var east_retreat_area: NodePath


onready var _retreat_areas := {
	GameConsts.EnemySpawnDirection.NORTH: get_node_or_null(north_retreat_area),
	GameConsts.EnemySpawnDirection.SOUTH: get_node_or_null(south_retreat_area),
	GameConsts.EnemySpawnDirection.WEST: get_node_or_null(west_retreat_area),
	GameConsts.EnemySpawnDirection.EAST	: get_node_or_null(east_retreat_area),
}


func _enter_tree():
	ServiceMgr.register_service(get_script(), self)


func get_retreat_to_position(retreat_direction) -> Vector3:
	var retreat_area: RandPointPlane
	if _retreat_areas.has(retreat_direction):
		retreat_area = _retreat_areas[retreat_direction]
	
	if retreat_area:
		return retreat_area.get_random_point()
	
	return Vector3.INF
