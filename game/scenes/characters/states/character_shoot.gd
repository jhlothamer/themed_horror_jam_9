extends CharacterBaseState


const SCENE_MAGIC_MISSILE = preload("res://scenes/projectiles/magic_missile.tscn")


export var deny_interaction_sound: NodePath
export var fire_from_position: NodePath
export var delay_before_firing := .7
export var delay_before_shooting_again := 1.0
export var shoot_sound: NodePath


onready var _deny_interaction_sound: AudioStreamPlayer = get_node_or_null(deny_interaction_sound)
onready var _fire_from_position: Position3D = get_node(fire_from_position)
onready var _shoot_sound: AudioStreamPlayer3D = get_node_or_null(shoot_sound)


var _target_enemy: Enemy
var _timer := 0.0
var _have_fired := false
var _target_pos: Vector3
var _firing := false


func _ready():
	SignalMgr.register_subscriber(self, "enemy_clicked")


func _on_enemy_clicked(enemy: CollisionObject) -> void:
	if !character.is_selected() or _firing or !character.can_shoot and character.can_melee:
		return
	var bounds_check_pt = Vector2(enemy.global_transform.origin.x, enemy.global_transform.origin.z)
	if !GameConsts.PLAY_AREA_BOUNDS.has_point(bounds_check_pt):
		return
	if !character.can_shoot or !character.has_required_resource_amount(GameConsts.RESOURCE_MANA, Projectile.MANA_USED):
		if !character.can_melee:
			if !character.can_shoot:
				_add_hud_message("Minions need active spell to shoot.  Have witch read from spellbook.")
			else:
				_add_hud_message("Not enough mana for magic missile!  Get more from mana pool.")
			if _deny_interaction_sound and !_deny_interaction_sound.is_playing():
				_deny_interaction_sound.play()
		return
	if _firing:
		breakpoint
	character.decrease_resource_amount(GameConsts.RESOURCE_MANA, Projectile.MANA_USED)
	_firing = true
	_target_enemy = enemy
	change_state(name)


func enter() -> void:
	_target_pos = _target_enemy.global_transform.origin
	character.look_at(_target_pos, Vector3.UP)
	_timer = 0.0
	_have_fired = false


func exit() -> void:
	_firing = false


func physics_process(delta):
	
	if !_target_enemy or !is_instance_valid(_target_enemy) or _target_enemy.is_dead():
		change_state("Idle")
		return
	
	_timer += delta
	
	if _timer > delay_before_firing and !_have_fired:
		_spawn_projectile()
		_have_fired = true
	if _timer >= delay_before_shooting_again:
		_timer = 0.0
		_firing = false
		_have_fired = false


func _spawn_projectile() -> void:
	if !is_instance_valid(_target_enemy):
		return
	var mm = SCENE_MAGIC_MISSILE.instance()
	mm.add_collision_exception_with(character)
	GameUtil.get_dynamic_parent(character).add_child(mm)
	mm.global_transform.origin = _fire_from_position.global_transform.origin
	mm.set_target_object(_target_enemy)
	if _shoot_sound and !_shoot_sound.is_playing():
		_shoot_sound.play()

