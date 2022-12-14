class_name Camera3DMovePan
extends Spatial

export (float, .1, 25) var move_speed: float = 10
export var north_action_name := "ui_up"
export var south_action_name := "ui_down"
export var west_action_name := "ui_left"
export var east_action_name := "ui_right"
export var disabled := false setget _set_disabled


func _set_disabled(value: bool) -> void:
	disabled = value
	set_physics_process(!disabled)


func _ready():
	self.disabled = disabled


func _physics_process(delta):
	var h_rot = global_rotation.y
	var x_input = Input.get_action_strength(east_action_name) - Input.get_action_strength(west_action_name)
	var z_input = Input.get_action_strength(south_action_name) - Input.get_action_strength(north_action_name)
	if x_input == 0 and z_input == 0:
		return
	var direction = Vector3(x_input, 0.0, z_input).rotated(Vector3.UP, h_rot).normalized()
	global_translate(direction * move_speed * delta)

