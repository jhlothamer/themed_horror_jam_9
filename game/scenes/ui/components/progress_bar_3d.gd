tool
class_name ProgressBar3D
extends MeshInstance


export var value := 50.0 setget _set_value
export var min_value := 0.0 setget _set_min_value
export var max_value := 100.0 setget _set_max_value
export var background_color := Color.black setget _set_background_color
export var progress_color := Color.green setget _set_progress_color



func _set_value(v: float) -> void:
	value = v
	_update_shader()


func _set_min_value(v: float) -> void:
	min_value = v
	_update_shader()


func _set_max_value(v: float) -> void:
	max_value = v
	_update_shader()


func _set_background_color(v: Color) -> void:
	background_color = v
	var mat: ShaderMaterial = mesh.material
	mat.set_shader_param("background_color", v)


func _set_progress_color(v: Color) -> void:
	progress_color = v
	var mat: ShaderMaterial = mesh.material
	mat.set_shader_param("progress_color", v)


func _ready():
	var mat: ShaderMaterial = mesh.material.duplicate()
	mesh.material = mat
	self.background_color = background_color
	self.progress_color = progress_color
	self.min_value = min_value
	self.max_value = max_value
	self.value = value


func _update_shader():
	var v:float = clamp(value, min_value, max_value)
	v = (v - min_value) / (max_value - min_value)
	var mat: ShaderMaterial = mesh.material
	mat.set_shader_param("progress_value", v)
