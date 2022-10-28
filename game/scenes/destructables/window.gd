class_name Window
extends Destructable


onready var _zombie_animation = $zombie_animations_frank_ilikethepixies
onready var _animation_player: AnimationPlayer = $zombie_animations_frank_ilikethepixies/AnimationPlayer
onready var _whole_mesh_instance = $window_broken_matrix
onready var _zombie_teleport_position: Position3D = $ZombieTeleportPosition3D
onready var _broken_mesh_instance = $broken_window_matrix


var _window_climber_queue := []
var _window_climber_active := false


func _on_destroid() -> void:
	_whole_mesh_instance.visible = false
	_broken_mesh_instance.visible =true


func queue_window_climber(enemy: Enemy) -> void:
	_window_climber_queue.append(enemy)



func _on_CheckWindowClimberQueueTimer_timeout():
	if _window_climber_active or !_window_climber_queue:
		return
	_window_climber_active = true
	var window_climber: Enemy = _window_climber_queue.pop_front()
	_perform_window_climb(window_climber)


func _perform_window_climb(window_climber: Enemy):
	window_climber.window_climb_started()
	_zombie_animation.visible = true
	_animation_player.play("FlipThroughWindow")
	yield(_animation_player,"animation_finished")
	_zombie_animation.visible = false
	window_climber.window_climb_finished(_zombie_teleport_position.global_transform.origin)
	_window_climber_active = false


func _on_HealthBar_progress_made(new_value, max_value):
	._on_HealthBar_progress_made(new_value, max_value)
	_whole_mesh_instance.visible = true
	_broken_mesh_instance.visible = false

