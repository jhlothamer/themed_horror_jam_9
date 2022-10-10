extends CharacterBaseState


const SCENE_MAGIC_MISSILE = preload("res://scenes/projectiles/magic_missile.tscn")

export var deny_interaction_sound: NodePath


onready var _deny_interaction_sound: AudioStreamPlayer3D = get_node_or_null(deny_interaction_sound)


var _target_enemy: Enemy


func _ready():
	SignalMgr.register_subscriber(self, "enemy_clicked")


func _on_enemy_clicked(enemy: CollisionObject) -> void:
	if !character.is_selected():
		return
	var witch: Witch = character
	if !witch.has_required_resource_amount(GameConsts.RESOURCE_MANA, Projectile.MANA_USED):
		if _deny_interaction_sound and !_deny_interaction_sound.is_playing():
			_deny_interaction_sound.play()
		return
	witch.decrease_resource_amount(GameConsts.RESOURCE_MANA, Projectile.MANA_USED)
	_target_enemy = enemy
	change_state(name)


func enter() -> void:
	var target_pos: Vector3 = _target_enemy.global_transform.origin
	character.look_at(target_pos, Vector3.UP)
	var mm = SCENE_MAGIC_MISSILE.instance()
	mm.add_collision_exception_with(character)
	GameUtil.get_dynamic_parent(character).add_child(mm)
	mm.global_transform.origin = character.global_transform.origin + Vector3.UP*.5
	mm.set_target_position(target_pos)
	change_state("Idle")



