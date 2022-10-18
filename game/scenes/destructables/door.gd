extends Destructable

onready var _whole_door: Spatial = $door_matrix
onready var _broken_door: Spatial = $broken_door_matrix
onready var _destroyed_door: Spatial = $completely_broken_door_matrix


func _on_HealthBar_value_changed(new_value: float) -> void:
	._on_HealthBar_value_changed(new_value)
	if !_whole_door:
		return
	
	if new_value == _health_bar.min_value:
		_whole_door.visible = false
		_broken_door.visible = false
		_destroyed_door.visible = true
		return
	
	var percent_whole = (new_value - _health_bar.min_value) / (_health_bar.max_value - _health_bar.min_value)
	
	if percent_whole <= .0:
		_whole_door.visible = false
		_broken_door.visible = false
		_destroyed_door.visible = true
		return
	if percent_whole >= .75:
		_whole_door.visible = true
		_broken_door.visible = false
		_destroyed_door.visible = false
	else:
		_whole_door.visible = false
		_broken_door.visible = true
		_destroyed_door.visible = false

