extends KinematicBody

const MOVE_TO_INDICATOR_SCENE = preload("res://scenes/ui/components/move_to_indicator.tscn")

export var horizontal_speed = 4.0
export var color: Color = Color("#187ed2")
export var debug_path := false


onready var _mesh:CapsuleMesh = $MeshInstance.mesh
onready var _outline_helper: OutlineHelper3D = $OutlineHelper3D


var _target_pos
var _interactable_target: CollisionObject
var _interaction_helper: InteractionHelper
var _move_to_indicator: Spatial
var _path := []
var _path_index := 0
var _path_debug_im: ImmediateGeometry


func _ready():
	SignalMgr.register_subscriber(self, "no_interactable_clicked")
	SignalMgr.register_subscriber(self, "interactable_clicked")
	SignalMgr.register_subscriber(self, "interaction_completed")
	_mesh.material.albedo_color = color


func _on_no_interactable_clicked(pos):
	if !_outline_helper.selected:
		return
	
	_stop_current_interaction()
	
	_target_pos = Vector3(pos.x, global_transform.origin.y, pos.z)
	_create_path()
	look_at(_target_pos, Vector3.UP)
	_create_move_to_indicator(_target_pos)

func _on_interactable_clicked(helper: InteractionHelper, clicked_object: CollisionObject):
	if !_outline_helper.selected:
		return
	
	_stop_current_interaction()
	_destroy_move_to_indicator()
	
	_interactable_target = clicked_object
	_interaction_helper = helper
	var pos = clicked_object.global_transform.origin
	_target_pos = Vector3(pos.x, global_transform.origin.y, pos.z)
	_create_path()
	look_at(_target_pos, Vector3.UP)


func _create_path() -> void:
	var map_id = get_world().get_navigation_map()
	_path = NavigationServer.map_get_path(map_id, global_transform.origin, _target_pos, true)
	_path_index = 0
	var y = global_transform.origin.y
	for i in _path.size():
		_path[i].y = y
	
	if _path.size() > 0 and _path[0] == global_transform.origin:
		_path.pop_front()
	if _path.back() != _target_pos:
		_path.push_back(_target_pos)
	_draw_path(_path)


func _draw_path(path_array) -> void:
	if !debug_path:
		return
	if !_path_debug_im:
		_path_debug_im = ImmediateGeometry.new()
		var m := SpatialMaterial.new()
		m.flags_unshaded = true
		m.albedo_color = Color.yellow
		_path_debug_im.material_override = m
		GameUtil.get_dynamic_parent(self).add_child(_path_debug_im)
	_path_debug_im.visible = true
	_path_debug_im.clear()
	var offset = Vector3.UP*.1
	_path_debug_im.begin(Mesh.PRIMITIVE_POINTS, null)
	_path_debug_im.add_vertex(path_array[0] + offset)
	_path_debug_im.add_vertex(path_array[path_array.size() - 1] + offset)
	_path_debug_im.end()
	_path_debug_im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in path_array:
		_path_debug_im.add_vertex(x + offset)
	_path_debug_im.end()


func _on_interaction_completed(helper: InteractionHelper, _clicked_object: CollisionObject):
	if helper != _interaction_helper:
		return
	_interaction_helper = null
	_interactable_target = null


func _stop_current_interaction() -> void:
	pass
	if !_interaction_helper:
		return
	_interaction_helper.stop_interaction()
	_interaction_helper = null
	_interactable_target = null


func _physics_process(delta):
	if _path_index >= _path.size():
		return
	
	var v = _path[_path_index] - global_transform.origin

	var lin_vel = v.normalized() * horizontal_speed
	var frame_move_v = lin_vel * delta
	if v.length() <= frame_move_v.length():
		_path_index += 1
		if _path_index >= _path.size():
			_destroy_move_to_indicator()
			_target_pos = null
			_path = []
	
	var c = move_and_collide(frame_move_v)
	if c:
		if c.collider == _interactable_target:
			_target_pos = null
			_path = []
			if _path_debug_im:
				_path_debug_im.visible = false
			_interaction_helper.start_interaction()
			_destroy_move_to_indicator()
		elif c.normal.dot(Vector3.UP) != 1.0:
			_target_pos = null
			_path = []
			if _path_debug_im:
				_path_debug_im.visible = false
			_destroy_move_to_indicator()


func _create_move_to_indicator(pos: Vector3) -> void:
	if !is_instance_valid(_move_to_indicator):
		_move_to_indicator = MOVE_TO_INDICATOR_SCENE.instance()
		var parent: Spatial = GameUtil.get_dynamic_parent(self)
		parent.add_child(_move_to_indicator)
	_move_to_indicator.global_transform.origin = pos

func _destroy_move_to_indicator() -> void:
	if !_move_to_indicator:
		return
	_move_to_indicator.queue_free()
	_move_to_indicator = null
	if _path_debug_im:
		_path_debug_im.visible = false

