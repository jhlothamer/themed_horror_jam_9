extends "res://scenes/levels/level1.gd"

onready var _path_follow1: PathFollow = $NavigationMeshInstance/Cauldron/Path/PathFollow
onready var _tween:Tween = $NavigationMeshInstance/Cauldron/Path/Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	_tween.interpolate_property(_path_follow1, "unit_offset", 0.0, 1.0, 1.0,Tween.TRANS_LINEAR,Tween.EASE_IN, 1.0)
	_tween.start()


