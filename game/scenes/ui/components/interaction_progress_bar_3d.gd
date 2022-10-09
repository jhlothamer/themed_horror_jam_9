tool
class_name InteractionProgressBar
extends "res://scenes/ui/components/progress_bar_3d.gd"

signal completed()
signal progress_made(new_value, max_value)


export var value_per_second_regain := 1.0
export var reset_on_complete := true


func _ready():
	set_physics_process(false)
	visible = false


func start() -> void:
	visible = true
	set_physics_process(true)


func stop() -> void:
	set_physics_process(false)


func reset() -> void:
	if reset_on_complete:
		self.value = 0.0
		visible = false
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var temp = self.value + value_per_second_regain * delta
	self.value = min(max_value, temp)
	if temp >= max_value:
		emit_signal("completed")
		reset()
		return
	emit_signal("progress_made", value, max_value)

