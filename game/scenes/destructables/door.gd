extends Destructable

onready var _whole_mesh_instance: MeshInstance = $WholeMeshInstance
onready var _broken_door = $test_broken_door

func _on_destroid() -> void:
	_whole_mesh_instance.visible = false
	_broken_door.visible = true


func _on_HealthBar_progress_made(new_value, max_value):
	._on_HealthBar_progress_made(new_value, max_value)
	_whole_mesh_instance.visible = true
	_broken_door.visible = false

