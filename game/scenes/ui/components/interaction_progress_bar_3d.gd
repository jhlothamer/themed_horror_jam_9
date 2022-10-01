tool
class_name InteractionProgressBar
extends "res://scenes/ui/components/progress_bar_3d.gd"

signal completed()


var _current_interaction_time := 0.0
var _current_speed_bonus_percent := 0.0


func _ready():
	self.value = 0.0
	set_physics_process(false)
	visible = false


func start() -> void:
	visible = true
	set_physics_process(true)


func stop() -> void:
	set_physics_process(false)


func reset() -> void:
	self.value = 0.0
	_current_interaction_time = 0.0
	set_physics_process(false)
	visible = false


func _physics_process(delta: float) -> void:
	_current_interaction_time += delta
	_current_interaction_time += delta * _current_speed_bonus_percent
	if _current_interaction_time >= max_value:
		emit_signal("completed")
		reset()
		return
	self.value = _current_interaction_time

