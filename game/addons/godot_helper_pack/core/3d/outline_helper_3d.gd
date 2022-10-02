class_name OutlineHelper3D
extends Node

const OUTLINE_SHADER_MATERIAL = preload("res://assets/materials_shaders/outline3D_smooth_normals_color.tres")

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


onready var _parent:CollisionObject = get_parent()


var _mesh_instance_outline_material: ShaderMaterial
var _selected_indicator: Spatial
var _selected := false


func _ready():
	if !_parent:
		return
	
	var mi: MeshInstance = get_node(mesh_instance_to_outline)
	if !mi:
		printerr("bad mesh_instance_to_outline mode path")
		return
	_mesh_instance_outline_material = OUTLINE_SHADER_MATERIAL.duplicate(true)
	_mesh_instance_outline_material.set_shader_param("outline_color", mouse_over_color)
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
	SignalMgr.register_subscriber(self, "no_selectable_clicked")


func _on_parent_mouse_enter():
	_mesh_instance_outline_material.set_shader_param("enabled", true)


func _on_parent_mouse_exit():
	_mesh_instance_outline_material.set_shader_param("enabled", false)

func _on_parent_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == button_index:
		if select_on_click:
			if !_selected:
				_selected = true
				_selected_indicator.visible = true
				emit_signal("selected", self)
		else:
			emit_signal("clicked", _parent)


func _on_selected(helperref):
	if helperref == self or !_selected:
		return
	_selected = false
	_selected_indicator.visible = false
	_mesh_instance_outline_material.set_shader_param("enabled", false)
	emit_signal("deselected")


func _on_no_selectable_clicked():
	if !_selected:
		return
	_selected = false
	_selected_indicator.visible = false
	_mesh_instance_outline_material.set_shader_param("enabled", false)
	emit_signal("deselected")

