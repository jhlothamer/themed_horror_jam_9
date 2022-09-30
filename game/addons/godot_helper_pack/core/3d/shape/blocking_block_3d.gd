tool
extends CollisionShapeEx


export var use_global_color := true setget _set_use_global_color
export var color: Color = Color.white setget _set_color


func _set_use_global_color(value: bool) -> void:
	if !use_global_color and value:
		_set_color(GodotHelperPackSettings.get_global_blocking_color())
	use_global_color = value

func _set_color(value):
	color = value
	if _shape_draw_3d:
		_shape_draw_3d.color = color


onready var _shape_draw_3d := $ShapeDraw3D


func _ready():
	if use_global_color:
		self.color = GodotHelperPackSettings.get_global_blocking_color()
	else:
		self.color = color
	
	if Engine.editor_hint:
		shape = shape.duplicate()
		return
	
	var parent = get_parent()
	if parent is CollisionObject:
		return
	
	yield(parent, "ready")
	
	var sb := StaticBody.new()
	parent.add_child(sb)
	parent.remove_child(self)
	sb.add_child(self)


func update_from_global_blocking_color(updated_color: Color) -> void:
	if !use_global_color:
		return
	color = updated_color
	_shape_draw_3d.color = color
