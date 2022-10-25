extends Spatial

onready var _path_follow:PathFollow = $Path/PathFollow
onready var _tween: Tween = $Tween


func _ready():
	_tween.interpolate_property(_path_follow, "unit_offset", 0.0, 1.0, 5.0)
	_tween.start()
