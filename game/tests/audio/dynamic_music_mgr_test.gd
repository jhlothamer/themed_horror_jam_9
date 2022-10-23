extends Control


signal enemy_detection_area_count_changed(new_count)

onready var _enemy_count_txt: TextEdit = $VBoxContainer/HBoxContainer/EnemyCountTxt


func _ready():
	SignalMgr.register_publisher(self, "enemy_detection_area_count_changed")


func _on_ChangeEnemyCountBtn_pressed():
	var new_count = int(_enemy_count_txt.text)
	emit_signal("enemy_detection_area_count_changed", new_count)
