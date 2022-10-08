class_name OutlineHelper3D
extends Node

#const OUTLINE_SHADER_MATERIAL = preload("res://assets/materials_shaders/fresnel_outline_mat.tres")
const OUTLINE_SHADER_MATERIAL = preload("res://assets/materials_shaders/outline_mat.tres")
const CONSTANT_OUTLINE_MIN_WIDTH = .3
const OUTLINE_ON_WIDTH = 1.0

# emitted when helper goes to a selected state
signal selected(helperref)
# emitted when helper goes to a deselected state
signal deselected()
# emitted when helper not is select_on_click mode and parent CollisionObject is clicked
signal clicked(clicked_object)


enum MouseButton {
	BUTTON_LEFT = BUTTON_LEFT,
	BUTTON_RIGHT = BUTTON_RIGHT,
	BUTTON_MIDDLE = BUTTON_MIDDLE,
}


export var mesh_instance_to_outline: NodePath
export var selected_indicator: NodePath
export var select_on_click := true
export (MouseButton) var button_index: int = BUTTON_LEFT
export var mouse_over_color := Color.aquamarine
export var outline_mesh_instance: NodePath
export var constant_outline := false
export var keep_selected_on_no_selectable_clicked := false

onready var _parent:CollisionObject = get_parent()


var selected := false


var _mesh_instance_outline_material: ShaderMaterial
var _selected_indicator: Spatial
var _outline_mesh_instance: MeshInstance

func _ready():
	if !_parent:
		return
	if !outline_mesh_instance.is_empty():
		_outline_mesh_instance = get_node_or_null(outline_mesh_instance)
		if _outline_mesh_instance:
			_outline_mesh_instance.visible = false
		else:
			printerr("bad outline_mesh_instance node path")
			return
	
	if !_outline_mesh_instance:
		var mi: MeshInstance = get_node(mesh_instance_to_outline)
		if !mi:
			printerr("bad mesh_instance_to_outline node path")
			return
		
		_mesh_instance_outline_material = OUTLINE_SHADER_MATERIAL.duplicate(true)
		if constant_outline:
			_mesh_instance_outline_material.set_shader_param("outline_color", Color.white)
			_mesh_instance_outline_material.set_shader_param("outline_width", CONSTANT_OUTLINE_MIN_WIDTH)
		else:
			_mesh_instance_outline_material.set_shader_param("outline_color", mouse_over_color)
			_mesh_instance_outline_material.set_shader_param("outline_width", .0)
		mi.material_overlay = _mesh_instance_outline_material

	if select_on_click:
		_selected_indicator = get_node(selected_indicator)
		if !_selected_indicator:
			printerr("bad selected_indicator node path")
			return
		_selected_indicator.visible = false
	
	_parent.connect("mouse_entered", self, "_on_parent_mouse_enter")
	_parent.connect("mouse_exited", self, "_on_parent_mouse_exit")
	_parent.connect("input_event", self, "_on_parent_input_event")
	SignalMgr.register_publisher(self, "selected")
	SignalMgr.register_subscriber(self, "selected")
	if !keep_selected_on_no_selectable_clicked:
		SignalMgr.register_subscriber(self, "no_selectable_clicked")


func _on_parent_mouse_enter():
	_show_outline()


func _on_parent_mouse_exit():
	_hide_outline()


func _on_parent_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == button_index:
		if select_on_click:
			if !selected:
				selected = true
				_selected_indicator.visible = true
				emit_signal("selected", self)
		else:
			emit_signal("clicked", _parent)


func _on_selected(helperref):
	if helperref == self or !selected:
		return
	selected = false
	_selected_indicator.visible = false
	_hide_outline()
	emit_signal("deselected")


func _on_no_selectable_clicked():
	if !selected:
		return
	selected = false
	_selected_indicator.visible = false
	_hide_outline()
	emit_signal("deselected")


func _show_outline() -> void:
	if _outline_mesh_instance:
		_outline_mesh_instance.visible = true
	else:
		_mesh_instance_outline_material.set_shader_param("outline_color", mouse_over_color)
		_mesh_instance_outline_material.set_shader_param("outline_width", OUTLINE_ON_WIDTH)
		


func _hide_outline() -> void:
	if _outline_mesh_instance:
		_outline_mesh_instance.visible = false
	else:
		if constant_outline:
			_mesh_instance_outline_material.set_shader_param("outline_color", Color.white)
			_mesh_instance_outline_material.set_shader_param("outline_width", CONSTANT_OUTLINE_MIN_WIDTH)
		else:
			_mesh_instance_outline_material.set_shader_param("outline_color", mouse_over_color)
			_mesh_instance_outline_material.set_shader_param("outline_width", .0)
