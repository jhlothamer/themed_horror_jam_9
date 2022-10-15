extends Spatial

export var horizontal_speed = 2.0
export var rand_point_plane: NodePath

onready var _rand_point_plane: RandPointPlane = get_node(rand_point_plane)


func get_random_point() -> Vector3:
	if !_rand_point_plane:
		return Vector3.INF
	
	return _rand_point_plane.get_random_point_from(global_transform.origin, 2.0)
