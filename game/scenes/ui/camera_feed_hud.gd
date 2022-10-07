extends CanvasLayer


export var camera_feed_viewports_parent: NodePath


onready var _camera_feed_viewport_texture: ViewportTexture = $MarginContainer/CameraFeedTextureRect.texture
onready var _ui_container: Control = $MarginContainer
onready var _number_label: Label = $MarginContainer/CameraFeedTextureRect/NumberLabel


var _camera_feed_viewports := []
var _camera_feed_index := 0


func _ready():
	_ui_container.visible = false
	var parent: Spatial = get_node(camera_feed_viewports_parent)
	if !parent:
		printerr("CameraFeedHud: bad camera_feed_viewports_parent node path")
		return
	for c in parent.get_children():
		if c is Viewport:
			_camera_feed_viewports.append(c.get_path())
	if !_camera_feed_viewports:
		printerr("CameraFeedHud: no viewports found in parent %s" % camera_feed_viewports_parent)
		return
	
	_camera_feed_viewport_texture.viewport_path = _camera_feed_viewports[_camera_feed_index]
	SignalMgr.register_subscriber(self, "crystal_ball_status_changed")


func _change_camera(delta: int) -> void:
	if !_camera_feed_viewports or !_ui_container.visible:
		return
	_camera_feed_index = wrapi(_camera_feed_index + delta, 0, _camera_feed_viewports.size())
	_camera_feed_viewport_texture.viewport_path = _camera_feed_viewports[_camera_feed_index]
	_number_label.text = str(_camera_feed_index + 1)


func _on_crystal_ball_status_changed(active: bool) -> void:
	_ui_container.visible = active


func _input(event):
	if event.is_action_pressed("next_camera"):
		_change_camera(1)
	elif event.is_action_pressed("previous_camera"):
		_change_camera(-1)

