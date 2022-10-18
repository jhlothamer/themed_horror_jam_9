class_name Zombie
extends Enemy


export var walk_speed := .5


onready var _damage_sounds:RandomAudioStreamPlayer3D = $DamageSounds
onready var _attack_sounds:RandomAudioStreamPlayer3D = $AttackSounds
onready var _animation_player: AnimationPlayer = $AnimationPlayer
onready var _run_horizontal_speed:float = horizontal_speed


var _state_animations := {
	"Idle": "Idle",
	"Walk": "Run",
	"Attack": ["1H Attack", "2H Attack"],
	"Die": "Die",
	"PostWindowClimb": "FlipThroughWindowStandup",
	"Retreat": "Walk",
	"Wander": "Walk",
}
var _animation_speeds := {
	"Run": .5,
	"1H Attack": 2.0,
	"2H Attack": 2.0,
}
var _looping_animations := [
	"Idle",
	"Walk",
	"Run",
]


func _on_damage() -> void:
	_damage_sounds.play()


func _on_Attack_attack_made():
	_attack_sounds.play()


func _get_animation_speed(anim_name) -> float:
	if _animation_speeds.has(anim_name):
		return _animation_speeds[anim_name]
	return 1.0


func _play_animation(anim_name) -> void:
	_animation_player.play(anim_name, -1, _get_animation_speed(anim_name))


func _on_StateMachine_state_changed(old_state, new_state):
	._on_StateMachine_state_changed(old_state, new_state)
	if _state_animations.has(new_state):
		var animation_name = _state_animations[new_state]
		if animation_name is Array:
			animation_name = ArrayUtil.get_rand(animation_name)
		if animation_name == "Walk":
			horizontal_speed = walk_speed
		else:
			horizontal_speed = _run_horizontal_speed
		_play_animation(animation_name)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FlipThroughWindowStandup":
		_state_machine.change_state("Walk")
		return
	
	if _looping_animations.has(anim_name):
		_play_animation(anim_name)
		return
	
	var attack_animations = _state_animations["Attack"]
	if attack_animations.has(anim_name):
		_play_animation(ArrayUtil.get_rand(attack_animations))

