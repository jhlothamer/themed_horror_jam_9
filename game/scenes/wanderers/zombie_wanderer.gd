extends "res://scenes/wanderers/wanderer_base.gd"


onready var _animation_player: AnimationPlayer = $zombie_animations_frank_ilikethepixies/AnimationPlayer


func _on_StateMachine_state_changed(_old_state, new_state):
	_animation_player.play(new_state)


func _on_AnimationPlayer_animation_finished(anim_name):
	_animation_player.play(anim_name)
