extends Area


export var active := false setget _set_active


var _in_range_enemies := []


func _set_active(value: bool) -> void:
	if active == value:
		return
	active = value
	if active:
		for i in _in_range_enemies:
			i.agression_level = GameConsts.EnemyAgressionLevel.HIGH


func _on_EnemyAgressionChangeArea_body_entered(body):
	_in_range_enemies.append(body)
	if active:
		body.agression_level = GameConsts.EnemyAgressionLevel.HIGH


func _on_EnemyAgressionChangeArea_body_exited(body):
	_in_range_enemies.erase(body)
