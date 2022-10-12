class_name NavigationPointMgr
extends Node

#node path of object to array of nodepaths to navigation points (Spatial)
export var object_to_navigation_points := {}


# object refs to array of Spatial objects
var _object_to_navigation_points := {}


func _enter_tree():
	ServiceMgr.register_service(get_script(), self)


func _ready():
	for key in object_to_navigation_points.keys():
		var obj = get_node(key)
		if !obj:
			printerr("NavigationPointMgr: bad object node path '%s'" % key)
			continue
		var nav_point_array = object_to_navigation_points[key]
		if !nav_point_array is Array:
			printerr("NavigationPointMgr: bad nav point array for key '%s'" % key)
			continue
		var nav_points := []
		for nav_point_nodepath in nav_point_array:
			if !nav_point_nodepath is NodePath:
				printerr("NavigationPointMgr: nav point for object '%s' is not a node path." % [key])
				continue
			var nav_point = get_node(nav_point_nodepath)
			if !nav_point is Spatial:
				printerr("NavigationPointMgr: bad nav point node path for object '%s' : '%s'" % [key, nav_point_nodepath])
				continue
			nav_points.append(nav_point)
		if !nav_points:
			printerr("NavigationPointMgr: bad empt nav point array for key '%s'" % key)
			continue
		_object_to_navigation_points[obj] = nav_points


func get_closest_navigation_point(navigator: Spatial, target_object: Spatial) -> Vector3:
	var closest_nav_point := Vector3.INF
	var min_distance := INF
	
	var navigator_global_position:Vector3 = navigator.global_transform.origin
	if _object_to_navigation_points.has(target_object):
		for i in _object_to_navigation_points[target_object]:
			var nav_point: Spatial = i
			var distance := navigator_global_position.distance_squared_to(nav_point.global_transform.origin)
			if distance < min_distance:
				min_distance = distance
				closest_nav_point = nav_point.global_transform.origin
			
	return closest_nav_point


