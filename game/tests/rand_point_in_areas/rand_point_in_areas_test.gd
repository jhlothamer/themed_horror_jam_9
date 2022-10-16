extends Spatial


#onready var _csg_poly: CSGPolygon = $NavigationMeshInstance/CSGPolygon
onready var _marker: Spatial = $Marker
onready var _rand_pt_plane: RandPointPlane = $NavigationMeshInstance/RandPointPlain


var _path_debug_im: ImmediateGeometry

#var _rnd := RandomNumberGenerator.new()

func _ready():
#	_rnd.randomize()
	_move_marker_random()

func _move_marker_random():
	#var v = _rand_pt_plane.get_random_point(_marker.global_transform.origin.y)
	var v = _rand_pt_plane.get_random_point_from(_marker.global_transform.origin, 5.0)
	if v == Vector3.INF:
		_marker.global_transform.origin = Vector3.ZERO
		print("Did not get random point!")
		return
	_marker.global_transform.origin = v
#	var rand_pt2d = _pick_rand_pt_in_area(_csg_poly.polygon)
#	var rand_pt3d = Vector3(rand_pt2d.x, 0.0, -rand_pt2d.y)
#	_marker.global_transform.origin = rand_pt3d
	

#func _pick_rand_pt_in_area(polygon: PoolVector2Array) -> Vector2:
#
#	var triangle_indices = Geometry.triangulate_polygon(polygon)
#	var triangles = []
#	for i in range(0, triangle_indices.size(), 3):
#		var pts = [polygon[triangle_indices[i]],
#			polygon[triangle_indices[i + 1]],
#			polygon[triangle_indices[i + 2]]]
#		triangles.append(pts)
#
#	var index:int = _rnd.randi() % triangles.size() # _polygon_triangle_count
#	var v = PolygonUtil.rand_vector2_in_triangle(triangles[index], 0, _rnd)
#
#	return v

func _make_path() -> void:
	var from := _marker.global_transform.origin
	_move_marker_random()
	var to := _marker.global_transform.origin
	#var path = _rand_pt_plane.get_path_inside(from, to)
	var map_id = get_world().get_navigation_map()
	var path = NavigationServer.map_get_path(map_id, from, to, true)
	#print(path)
	_draw_path(path)
	


func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_SPACE and event.is_pressed() and !event.is_echo():
			#_move_marker_random()
			_make_path()

func _draw_path(path_array) -> void:
	if !_path_debug_im:
		_path_debug_im = ImmediateGeometry.new()
		var m := SpatialMaterial.new()
		m.flags_unshaded = true
		m.albedo_color = Color.yellow
		_path_debug_im.material_override = m
		GameUtil.get_dynamic_parent(self).add_child(_path_debug_im)
	_path_debug_im.visible = true
	_path_debug_im.clear()
	var offset = Vector3.UP*.1
	_path_debug_im.begin(Mesh.PRIMITIVE_POINTS, null)
	_path_debug_im.add_vertex(path_array[0] + offset)
	_path_debug_im.add_vertex(path_array[path_array.size() - 1] + offset)
	_path_debug_im.end()
	_path_debug_im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in path_array:
		_path_debug_im.add_vertex(x + offset)
	_path_debug_im.end()
