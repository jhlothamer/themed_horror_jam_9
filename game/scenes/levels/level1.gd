extends Spatial


onready var _main_camera_flags: Spatial = $MainCameraFlags


func _ready():
	randomize()
	_main_camera_flags.visible = true


