extends Spatial

onready var _click_collision_marker: Spatial = $ClickCollisionMarker


func _ready():
	_click_collision_marker.visible = false
	SignalMgr.register_subscriber(self, "no_interactable_clicked")


func _on_no_interactable_clicked(position):
	_click_collision_marker.visible = true
	_click_collision_marker.global_transform.origin = position
