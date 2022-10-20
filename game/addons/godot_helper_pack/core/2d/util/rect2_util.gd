class_name Rect2Util
extends Node

static func make_polygon(r: Rect2) -> Array:
	var pts = []
	#top right
	pts.append(Vector2(r.end.x, r.position.y))
	#bottom right
	pts.append(r.end)
	#bottom left
	pts.append(Vector2(r.position.x, r.end.y))
	#top left
	pts.append(r.position)
	return pts


static func clamp_point(r: Rect2, pt: Vector2) -> Vector2:
	if !r.has_point(pt):
		pt.x = clamp(pt.x, r.position.x, r.end.x)
		pt.y = clamp(pt.y, r.position.y, r.end.y)
	
	return pt
