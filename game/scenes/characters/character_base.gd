class_name Character
extends KinematicBody


export var horizontal_speed = 4.0


onready var _outline_helper: OutlineHelper3D = $OutlineHelper3D


func is_selected() -> bool:
	return _outline_helper.selected

