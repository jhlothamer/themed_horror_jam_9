extends Spatial

onready var _click_collision_marker:Spatial = $ClickCollisionMarker


func _ready():
	_click_collision_marker.visible = false


func _on_Area_mouse_entered():
	return
	print("mouse entered")


func _on_Area_mouse_exited():
	return
	print("mouse exited")


func _on_Area_input_event(camera, event, position, normal, shape_idx):
	return
	if event is InputEventMouseButton and event.pressed:
		print("clicked on box")


func _on_RigidBody_mouse_exited():
	return
	print("mouse exited")


func _on_RigidBody_mouse_entered():
	return
	print("mouse entered")


func _on_RigidBody_input_event(camera, event, position, normal, shape_idx):
	return
	if event is InputEventMouseButton and event.pressed:
		print("clicked on box")


func _on_KinematicBody_mouse_exited():
	return
	print("mouse exited")


func _on_KinematicBody_mouse_entered():
	return
	print("mouse entered")


func _on_KinematicBody_input_event(camera, event, position, normal, shape_idx):
	return
	if event is InputEventMouseButton and event.pressed:
		print("clicked on box")
