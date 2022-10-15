class_name PolygonUtil
extends Node


static func get_midpoint(polygon: PoolVector2Array) -> Vector2:
	var mid_point = Vector2.ZERO
	for v in polygon:
		mid_point += v
	mid_point = mid_point / float(polygon.size())
	return mid_point


static func rand_vector2_in_triangle(pts: Array, starting_index: int = 0, rnd: RandomNumberGenerator = null) -> Vector2:
	if !pts or pts.size() < starting_index + 3:
		return Vector2.INF
	
	var a: Vector2 = pts[starting_index + 1] - pts[starting_index]
	var b: Vector2 = pts[starting_index + 2] - pts[starting_index]

	var u1: float = randf() if !rnd else rnd.randf()
	var u2: float = randf() if !rnd else rnd.randf()

	if u1 + u2 > 1.0:
		u1 = 1.0 - u1
		u2 = 1.0 - u2

	var c: Vector2 = u1*a + u2*b

	return c + pts[0]
