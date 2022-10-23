extends Spatial

export var enable_debug_view := false


onready var _main_camera_flags: Spatial = $MainCameraFlags
onready var _camera_move_pan = $Camera3DMovePan

func _ready():
	randomize()
	if !enable_debug_view:
		_main_camera_flags.visible = true
	else:
		_camera_move_pan.disabled = false

