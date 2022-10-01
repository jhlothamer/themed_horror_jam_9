extends KinematicBody

export var horizontal_speed = 4.0
export var color: Color = Color("#187ed2")

onready var _mesh:CapsuleMesh = $CollisionShape/MeshInstance.mesh

var _target_pos
var _interactable_target: CollisionObject
var _selected := false


func _ready():
	SignalMgr.register_subscriber(self, "no_interactable_clicked")
	SignalMgr.register_subscriber(self, "clicked")
	_mesh.material.albedo_color = color


func _on_no_interactable_clicked(pos):
	if !_selected:
		return
	_target_pos = Vector3(pos.x, global_transform.origin.y, pos.z)
	look_at(_target_pos, Vector3.UP)


func _on_clicked(clicked_object: CollisionObject):
	if !_selected:
		return
	if clicked_object.collision_layer & GameConsts.PhysLayer.INTERACTABLE == 0:
		return
	_interactable_target = clicked_object
	var pos = clicked_object.global_transform.origin
	_target_pos = Vector3(pos.x, global_transform.origin.y, pos.z)
	look_at(_target_pos, Vector3.UP)


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
			_interactable_target.queue_free()
			_interactable_target = null
		elif c.normal.dot(Vector3.UP) != 1.0:
			_target_pos = null



func _on_OutlineHelper3D_selected(helperref):
	_selected = true


func _on_OutlineHelper3D_deselected():
	_selected = false
