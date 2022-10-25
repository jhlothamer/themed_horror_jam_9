extends Spatial


onready var _window = $Window

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	_window.damage(_window.starting_health)
