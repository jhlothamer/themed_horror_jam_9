class_name RandPointPlane
extends CSGPolygon


export var hide_at_runtime := true


var _rnd := RandomNumberGenerator.new()
var _polygon_triangles := []


func _ready():
	_rnd.randomize()
	if hide_at_runtime:
		visible = false
	
	
	_populate_polygon_triangles()


func _populate_polygon_triangles() -> void:
	var triangle_indices = Geometry.triangulate_polygon(polygon)

	for i in range(0, triangle_indices.size(), 3):
		var pts = [polygon[triangle_indices[i]],
			polygon[triangle_indices[i + 1]],
			polygon[triangle_indices[i + 2]]]
		_polygon_triangles.append(pts)


func get_random_point(y: float = 0.0) -> Vector3:
	if !_polygon_triangles:
		return Vector3.INF
	var index:int = _rnd.randi() % _polygon_triangles.size() # _polygon_triangle_count
	var v: Vector2 = PolygonUtil.rand_vector2_in_triangle(_polygon_triangles[index], 0, _rnd)

	return Vector3(v.x, y, -v.y)


func get_random_point_from(from: Vector3, min_distance: float = 1.0, attempts: int = 10) -> Vector3:
	var min_distance_sq := min_distance * min_distance
	for i in attempts:
		var v = get_random_point(from.y)
		if v.distance_squared_to(from) >= min_distance_sq:
			return v
	
	return Vector3.INF

