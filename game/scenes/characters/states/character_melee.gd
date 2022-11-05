extends CharacterBaseState

export var delay_before_firing := .7
export var delay_before_shooting_again := 1.0
export var enemy_move_distance_tollerance := 1.5
export var damage := 5.0

onready var _enemy_move_distance_tollerance_sq = enemy_move_distance_tollerance *enemy_move_distance_tollerance


var _target_enemy: Enemy
var _timer := 0.0
var _have_fired := false
var _target_pos: Vector3
var _firing := false

func _ready():
	SignalMgr.register_subscriber(self, "enemy_clicked")


func _on_enemy_clicked(enemy: CollisionObject) -> void:
	if !character.is_selected() or _firing:
		return
	if character.has_required_resource_amount(GameConsts.RESOURCE_MANA, Projectile.MANA_USED) and character.can_shoot:
		return
	var bounds_check_pt = Vector2(enemy.global_transform.origin.x, enemy.global_transform.origin.z)
	if !GameConsts.PLAY_AREA_BOUNDS.has_point(bounds_check_pt):
		return
	if _firing:
		breakpoint
	_firing = true
	_target_enemy = enemy
	change_state(name)



func enter() -> void:
	set_blackboard_data(CharacterBaseState.BBDATA_TARGET_ENEMY, _target_enemy)
	push_state("WalkTo")
	_timer = 0.0
	_have_fired = false

func reenter(_from_state: String) -> void:
	if !is_instance_valid(_target_enemy):
		change_state("Idle")
		return
	_target_pos = _target_enemy.global_transform.origin
	character.look_at(_target_pos, Vector3.UP)
	


func exit() -> void:
	_firing = false


func physics_process(delta):
	if !is_instance_valid(_target_enemy) or _target_enemy.is_dead():
		change_state("Idle")
		return

	if character.global_transform.origin.distance_squared_to(_target_enemy.global_transform.origin) >= _enemy_move_distance_tollerance_sq:
		set_blackboard_data(CharacterBaseState.BBDATA_TARGET_ENEMY, _target_enemy)
		push_state("WalkTo")
	
	_timer += delta
	
	if _timer > delay_before_firing and !_have_fired:
		_target_enemy.damage(damage)
		_have_fired = true
	if _timer >= delay_before_shooting_again:
		_timer = 0.0
		_firing = false
		_have_fired = false

