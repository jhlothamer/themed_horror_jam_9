extends KinematicBody

export var horizontal_speed = 4.0
export var color: Color = Color("#187ed2")

onready var _mesh:CapsuleMesh = $CollisionShape/MeshInstance.mesh

var _target_pos
var _interactable_target: CollisionObject
var _interaction_helper: InteractionHelper
var _selected := false


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


func _on_interactable_clicked(helper: InteractionHelper, clicked_object: CollisionObject):
	if !_selected:
		return
#	if clicked_object.collision_layer & GameConsts.PhysLayer.INTERACTABLE == 0:
#		return
	
	_stop_current_interaction()
	
	_interactable_target = clicked_object
	_interaction_helper = helper
	var pos = clicked_object.global_transform.origin
	_target_pos = Vector3(pos.x, global_transform.origin.y, pos.z)
	look_at(_target_pos, Vector3.UP)

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
	if !_target_pos:
		return
	var v:Vector3 = _target_pos - global_transform.origin
	var lin_vel = v.normalized() * horizontal_speed
	var frame_move_v = lin_vel * delta
	if v.length() <= frame_move_v.length():
		_target_pos = null
		return
#	move_and_slide_with_snap(v, Vector3.DOWN, Vector3.UP)
#	for i in get_slide_count():
#		var c := get_slide_collision(i)
#		if c.normal.dot(Vector3.UP) != 1.0:
#			_target_pos = null
#			break
	var c = move_and_collide(frame_move_v)
	if c:
		if c.collider == _interactable_target:
			_target_pos = null
			_interaction_helper.start_interaction()
		elif c.normal.dot(Vector3.UP) != 1.0:
			_target_pos = null



func _on_OutlineHelper3D_selected(_helperref):
	_selected = true


func _on_OutlineHelper3D_deselected():
	_selected = false
