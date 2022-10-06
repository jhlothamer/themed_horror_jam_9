extends Enemy

onready var _damage_sounds:RandomAudioStreamPlayer3D = $DamageSounds
onready var _attack_sounds:RandomAudioStreamPlayer3D = $AttackSounds

func _on_damage() -> void:
	_damage_sounds.play()


func _on_Attack_attack_made():
	_attack_sounds.play()
