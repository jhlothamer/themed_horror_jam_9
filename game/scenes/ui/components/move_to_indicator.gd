extends Spatial

onready var _animation_player: AnimationPlayer = $character_selection_animation_matrix/AnimationPlayer


func animate() -> void:
	_animation_player.play("Action")
