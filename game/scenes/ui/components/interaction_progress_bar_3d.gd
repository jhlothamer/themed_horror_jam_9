tool
class_name InteractionProgressBar
extends "res://scenes/ui/components/progress_bar_3d.gd"

signal completed()
signal progress_made(new_value, max_value)


export var value_per_second_regain := 1.0
export var reset_on_complete := true
export var speed_regain_on_active_spell := 0.0

var _spell_active := false

func _ready():
	set_physics_process(false)
	visible = false
	SignalMgr.register_subscriber(self, "spell_activated")
	SignalMgr.register_subscriber(self, "spell_deactivated")


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
	if _spell_active:
		temp += speed_regain_on_active_spell * delta
	self.value = min(max_value, temp)
	if temp >= max_value:
		emit_signal("completed")
		reset()
		return
	emit_signal("progress_made", value, max_value)


func _on_spell_activated():
	_spell_active = true


func _on_spell_deactivated():
	_spell_active = false


