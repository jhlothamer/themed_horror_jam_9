extends EnemeyBaseState


func enter() -> void:
	if !_check_agression_level():
		yield(get_tree().create_timer(1.0), "timeout")
		if !_check_agression_level():
			change_state("Walk")
		

func _check_agression_level() -> bool:
	if enemy.agression_level == GameConsts.EnemyAgressionLevel.HIGH:
		change_state("Walk")
		return true
	elif enemy.agression_level == GameConsts.EnemyAgressionLevel.MEDIUM:
		change_state("TestDefense")
		return true
	elif enemy.agression_level == GameConsts.EnemyAgressionLevel.LOW:
		change_state("Wander")
		return true

	return false



