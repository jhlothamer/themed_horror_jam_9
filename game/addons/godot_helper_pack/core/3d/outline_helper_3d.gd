class_name OutlineHelper3D
extends Node

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


export var outline_mesh_instance: NodePath
export var select_on_click := true
export (MouseButton) var button_index: int = BUTTON_LEFT


onready var _parent:CollisionObject = get_parent()


var _outline_mesh_instance: MeshInstance
var _selected := false


func _ready():
	if !_parent:
		return
	_outline_mesh_instance = get_node(outline_mesh_instance)
	if !_outline_mesh_instance:
		return
	_outline_mesh_instance.visible = false
	_parent.connect("mouse_entered", self, "_on_parent_mouse_enter")
	_parent.connect("mouse_exited", self, "_on_parent_mouse_exit")
	_parent.connect("input_event", self, "_on_parent_input_event")
	SignalMgr.register_publisher(self, "selected")
	SignalMgr.register_subscriber(self, "selected")
	SignalMgr.register_subscriber(self, "no_selectable_clicked")


func _on_parent_mouse_enter():
	_outline_mesh_instance.visible = true


func _on_parent_mouse_exit():
	if !_selected:
		_outline_mesh_instance.visible = false

func _on_parent_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == button_index:
		if select_on_click:
			if !_selected:
				_selected = true
				emit_signal("selected", self)
		else:
			emit_signal("clicked", _parent)


func _on_selected(helperref):
	if helperref == self or !_selected:
		return
	_selected = false
	_outline_mesh_instance.visible = false
	emit_signal("deselected")


func _on_no_selectable_clicked():
	if !_selected:
		return
	_selected = false
	_outline_mesh_instance.visible = false
	emit_signal("deselected")

