extends EnemeyBaseState

func enter() -> void:
	print("Zombie:%s - entered" % name)
	change_state("Walk")
