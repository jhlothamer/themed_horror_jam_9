extends Spatial

const SCENE_MAGIC_MISSILE = preload("res://scenes/projectiles/magic_missile.tscn")

onready var start_pos: Vector3 = $Position3D.global_transform.origin
onready var target_pos: Vector3 = $Position3D2.global_transform.origin


func _ready():
	pass # Replace with function body.
	spawn_projectile()


func spawn_projectile() -> void:
	pass
	var mm = SCENE_MAGIC_MISSILE.instance()
	#mm.speed = 1.0
	add_child(mm)
	mm.global_transform.origin = start_pos
	mm.set_target_position(target_pos)
