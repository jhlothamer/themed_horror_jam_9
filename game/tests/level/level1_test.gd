extends "res://scenes/levels/level1.gd"


#onready var _tween:Tween = $NavigationMeshInstance/Cauldron/GreenVaporParticles/Tween
#onready var _path_follows := [
#	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path1/PathFollow,
#	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path2/PathFollow,
#	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path3/PathFollow,
#	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path4/PathFollow,
#]
#onready var _particles := [
#	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path1/PathFollow/Particles,
#	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path2/PathFollow/Particles,
#	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path3/PathFollow/Particles,
#	$NavigationMeshInstance/Cauldron/GreenVaporParticles/Path4/PathFollow/Particles,
#]
#onready var _cauldron = $NavigationMeshInstance/Cauldron

func _ready():
	pass
	#yield(get_tree().create_timer(5.0), "timeout")




func _on_Cauldron_game_won_sequence_began():
	for particles in _particles:
		particles.emitting = true

	for path_follow in _path_follows:
			_tween.interpolate_property(path_follow, "unit_offset", 0.0, 1.0, 2.5,Tween.TRANS_LINEAR,Tween.EASE_IN, 1.0)
	_tween.start()
	yield(get_tree().create_timer(1.0), "timeout")
	_cauldron.hide_potion()
	#_sound.play()
	yield(_tween, "tween_all_completed")
	for particles in _particles:
		particles.emitting = false
