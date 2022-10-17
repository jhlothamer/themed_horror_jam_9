class_name WardArea
extends Area

signal deactivated()


export var enemy_ward_count := 5
export var active := false setget _set_active


var _current_enemy_warded_count := 0


func _set_active(value: bool) -> void:
	active = value
	if active:
		_current_enemy_warded_count = enemy_ward_count


func _ready():
	self.active = active


func _on_WardArea_body_entered(body):
	if !body is Enemy or _current_enemy_warded_count == 0:
		return

	body.ward()

	_current_enemy_warded_count -= 1

	if _current_enemy_warded_count == 0:
		emit_signal("deactivated")
		active = false


