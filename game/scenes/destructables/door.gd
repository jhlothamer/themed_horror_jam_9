extends Destructable

onready var _mesh_instance: MeshInstance = $MeshInstance

func _on_destroid() -> void:
	_mesh_instance.visible = false
	

