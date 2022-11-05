extends Spatial

export var enable_debug_view := false


onready var _main_camera_flags: Spatial = $MainCameraFlags
onready var _camera_move_pan = $Camera3DMovePan
onready var _tween:Tween = $NavigationMeshInstance/Cauldron/GreenVaporParticles/Tween
onready var _path_follows := [
	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path1/PathFollow,
	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path2/PathFollow,
	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path3/PathFollow,
	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path4/PathFollow,
]
onready var _particles := [
	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path1/PathFollow/Particles,
	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path2/PathFollow/Particles,
	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path3/PathFollow/Particles,
	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path4/PathFollow/Particles,
]
onready var _cauldron = $NavigationMeshInstance/Cauldron


func _ready():
	randomize()
	if !enable_debug_view:
		_main_camera_flags.visible = true
	else:
		_camera_move_pan.disabled = false
#	_beginning_game_messages()
#
#
#func _beginning_game_messages() -> void:
#	var hud: HUD = ServiceMgr.get_service(HUD)
#	yield(get_tree().create_timer(2.0),"timeout")
#	hud.add_message("Left click witch or minion to select them.")
#	yield(get_tree().create_timer(4.0),"timeout")
#	hud.add_message("Right click to command witch or minion to move or use/repair something.")
#	yield(get_tree().create_timer(4.0),"timeout")
#	hud.add_message("Better get someone on that cauldron!  The zombies can't be vanquished till it's finished!")
#	yield(get_tree().create_timer(10.0),"timeout")
#	hud.add_message("Don't forget to have minions stock up on wood so they're ready to make repairs.")
#	yield(get_tree().create_timer(10.0),"timeout")
#	hud.add_message("Have witch get mana from mana pool.  Then she can cast magic missiles.")


func _on_Cauldron_game_won_sequence_began():
	for particles in _particles:
		particles.emitting = true

	for path_follow in _path_follows:
			if !_tween.interpolate_property(path_follow, "unit_offset", 0.0, 1.0, 2.5,Tween.TRANS_LINEAR,Tween.EASE_IN, 1.0):
				printerr("Level1: could not interpolate unit_offset property for green vapor path follow")
	if !_tween.start():
		printerr("Level1: could not start tween for green vapor particles")
	yield(get_tree().create_timer(1.0), "timeout")
	_cauldron.hide_potion()
	#_sound.play()
	yield(_tween, "tween_all_completed")
	for particles in _particles:
		particles.emitting = false
