class_name Projectile
extends KinematicBody


const MANA_USED := 10


export var speed := 1.0
export var damage := 10
export var target_position: Vector3


var target_object: Spatial


var _direction: Vector3


func set_target_object(object: Spatial) -> void:
	target_object = object
	set_target_position(target_object.global_transform.origin)


func set_target_position(target_pos) -> void:
	target_position = target_pos
	var temp = Vector3(target_position.x, global_transform.origin.y, target_position.z)
	_direction = global_transform.origin.direction_to(temp)
	look_at(temp, Vector3.UP)


func _update_target_position() -> void:
	if !target_object or !is_instance_valid(target_object):
		return
	set_target_position(target_object.global_transform.origin)


func _physics_process(delta):
	_update_target_position()
	var move_vector = _direction * speed * delta
	var c := move_and_collide(move_vector)
	if c and c.collider:
		if c.collider.has_method("collide"):
			c.collider.collide(self)
		queue_free()


func _on_VisibilityNotifier_screen_exited():
	queue_free()

