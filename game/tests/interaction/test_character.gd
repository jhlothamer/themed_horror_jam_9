extends KinematicBody

const MOVE_TO_INDICATOR_SCENE = preload("res://scenes/ui/components/move_to_indicator.tscn")

export var horizontal_speed = 4.0
export var color: Color = Color("#187ed2")
export var debug := false


onready var _mesh:CapsuleMesh = $MeshInstance.mesh


var _target_pos
var _interactable_target: CollisionObject
var _interaction_helper: InteractionHelper
var _selected := false
var _move_to_indicator: Spatial


func _ready():
	SignalMgr.register_subscriber(self, "no_interactable_clicked")
	SignalMgr.register_subscriber(self, "interactable_clicked")
	SignalMgr.register_subscriber(self, "interaction_completed")
	_mesh.material.albedo_color = color


func _on_no_interactable_clicked(pos):
	if !_selected:
		return
	
	_stop_current_interaction()
	
	_target_pos = Vector3(pos.x, global_transform.origin.y, pos.z)
	look_at(_target_pos, Vector3.UP)
	_create_move_to_indicator(_target_pos)

var _debug_phys_process := false
func _on_interactable_clicked(helper: InteractionHelper, clicked_object: CollisionObject):
	if !_selected:
		return
	if debug:
		#breakpoint
		_debug_phys_process = true
	_stop_current_interaction()
	
	_interactable_target = clicked_object
	_interaction_helper = helper
	var pos = clicked_object.global_transform.origin
	_target_pos = Vector3(pos.x, global_transform.origin.y, pos.z)
	look_at(_target_pos, Vector3.UP)
	_destroy_move_to_indicator()


func _on_interaction_completed(helper: InteractionHelper, clicked_object: CollisionObject):
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
	if _debug_phys_process:
		breakpoint
	if _target_pos == null:
		return
	var v:Vector3 = _target_pos - global_transform.origin
	var lin_vel = v.normalized() * horizontal_speed
	var frame_move_v = lin_vel * delta
	if v.length() <= frame_move_v.length():
		_target_pos = null
		_destroy_move_to_indicator()
		return
	
	var c = move_and_collide(frame_move_v)
	if c:
		if c.collider == _interactable_target:
			_target_pos = null
			_interaction_helper.start_interaction()
			_destroy_move_to_indicator()
		elif c.normal.dot(Vector3.UP) != 1.0:
			_target_pos = null
			_destroy_move_to_indicator()


func _on_OutlineHelper3D_selected(_helperref):
	_selected = true


func _on_OutlineHelper3D_deselected():
	_selected = false


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

