class_name WardMgr
extends Node

signal ward_activated()
signal ward_deactivated()

export var north_camera: NodePath
export var west_camera: NodePath
export var east_camera: NodePath
export var north_ward_area: NodePath
export var west_ward_area: NodePath
export var east_ward_area: NodePath
export var allow_multiple_wards := false


var disabled := false


onready var _north_camera: Camera = get_node(north_camera)
onready var _west_camera: Camera = get_node(west_camera)
onready var _east_camera: Camera = get_node(east_camera)
onready var _camera_name_to_ward_area := {
	get_node(north_camera).name: get_node(north_ward_area),
	get_node(west_camera).name: get_node(west_ward_area),
	get_node(east_camera).name: get_node(east_ward_area),
}


func _enter_tree():
	ServiceMgr.register_service(get_script(), self)


func _ready():
	for i in _camera_name_to_ward_area.keys():
		if !_camera_name_to_ward_area[i] is WardArea:
			printerr("WardMgr: bad ward area in settings")
			continue
		var ward_area:WardArea = _camera_name_to_ward_area[i]
		if OK != ward_area.connect("deactivated", self, "_on_ward_area_deactivated", [i]):
			printerr("WardMgr: Could not connect to deactivated signal for %s" % ward_area.get_path())
	SignalMgr.register_publisher(self, "ward_activated")
	SignalMgr.register_publisher(self, "ward_deactivated")


func _get_current_camera_feed_name() -> String:
	var camera_feed_hud:CameraFeedHud = ServiceMgr.get_service(CameraFeedHud)
	if !camera_feed_hud:
		printerr("WardMgr: no CameraFeedHud service.")
		return ""
	return camera_feed_hud.get_current_camera_feed_name()


func _get_ward_area(camera_name: String) -> WardArea:
	if !_camera_name_to_ward_area.has(camera_name):
		printerr("WardMgr: unknown camera name : '%s'" % camera_name)
		return null
	
	var ward_area: WardArea = _camera_name_to_ward_area[camera_name]
	if !ward_area:
		printerr("WardMgr: bad ward area for camera : '%s'" % camera_name)
		return null
	
	return ward_area


func _are_any_ward_areas_active() -> bool:
	for ward_area in _camera_name_to_ward_area.values():
		if ward_area.active:
			return true
	return false


func _set_camera_feed_ward(camera_name: String, warded: bool) -> void:
	var camera_feed_hud:CameraFeedHud = ServiceMgr.get_service(CameraFeedHud)
	if !camera_feed_hud:
		printerr("WardMgr: no CameraFeedHud service.")
		return
	camera_feed_hud.set_camera_feed_ward(camera_name, warded)


func place_ward() -> bool:
	if disabled:
		return false
	if !allow_multiple_wards and _are_any_ward_areas_active():
		return false
	
	var curr_camera_name = _get_current_camera_feed_name()
	var ward_area = _get_ward_area(curr_camera_name)
	if !ward_area:
		return false
	if ward_area.active:
		return false
	
	ward_area.active = true
	_set_camera_feed_ward(curr_camera_name, true)
	emit_signal("ward_activated")
	
	return true


func _on_ward_area_deactivated(camera_name: String) -> void:
	_set_camera_feed_ward(camera_name, false)
	emit_signal("ward_deactivated")


