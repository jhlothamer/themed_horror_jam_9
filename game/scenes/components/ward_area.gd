class_name WardArea
extends Area

signal deactivated()


export var enemy_ward_count := 5
export var active := false setget _set_active

var _current_enemy_warded_count := 0
var _enemies := []

func _set_active(value: bool) -> void:
	active = value
	if active:
		_current_enemy_warded_count = enemy_ward_count
		if _enemies:
			for enemy in _enemies:
				enemy.ward()
				_current_enemy_warded_count -= 1
				if _current_enemy_warded_count == 0:
					break


func _ready():
	self.active = active


func _on_WardArea_body_entered(body):
	if !body is Enemy:
		return
	
	if _current_enemy_warded_count == 0:
		_enemies.append(body)
		return

	body.ward()

	_current_enemy_warded_count -= 1

	if _current_enemy_warded_count == 0:
		emit_signal("deactivated")
		active = false




func _on_WardArea_body_exited(body):
	_enemies.erase(body)
