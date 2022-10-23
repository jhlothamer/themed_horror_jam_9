extends Area

signal enemy_detection_area_count_changed(new_count)


var _enemies_in_area := []


func _ready():
	SignalMgr.register_publisher(self, "enemy_detection_area_count_changed")


func _on_EnemyDetectionArea_body_entered(body):
	_enemies_in_area.append(body)
	emit_signal("enemy_detection_area_count_changed", _enemies_in_area.size())


func _on_EnemyDetectionArea_body_exited(body):
	_enemies_in_area.erase(body)
	emit_signal("enemy_detection_area_count_changed", _enemies_in_area.size())


