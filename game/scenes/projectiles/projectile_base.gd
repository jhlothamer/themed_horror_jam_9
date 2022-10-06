class_name Projectile
extends KinematicBody

const MANA_USED := 10

export var speed := 1.0
export var damage := 10.0

export var target_position: Vector3

var _direction: Vector3


func set_target_position(target_pos) -> void:
	target_position = target_pos
	var temp = Vector3(target_position.x, global_transform.origin.y, target_position.z)
	_direction = global_transform.origin.direction_to(temp)
	look_at(temp, Vector3.UP)


func _physics_process(delta):
	var move_vector = _direction * speed * delta
	var c := move_and_collide(move_vector)
	if c and c.collider:
		if c.collider.has_method("collide"):
			c.collider.collide(self)
		queue_free()

