extends EnemeyBaseState

export var rand_death_sounds: NodePath

onready var _rand_death_sounds:RandomAudioStreamPlayer3D = get_node_or_null(rand_death_sounds)


func enter() -> void:
	enemy._disable_collisions()
	if _rand_death_sounds:
		_rand_death_sounds.play()
		yield(_rand_death_sounds, "finished")
	enemy.queue_free()
