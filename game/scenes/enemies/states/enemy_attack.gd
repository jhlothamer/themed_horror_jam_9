extends EnemeyBaseState


signal attack_made()


export var character_detect_area: NodePath


var _target_character: Character
var _target_destructable: Destructable
var _attack_counter := 0
var _attack_limit := -1
var _attack_limit_next_state := ""


func _ready():
	var area: Area = get_node(character_detect_area)
	if !area:
		printerr("Enemy:Attack - bad character_detect_area node path")
		return
	
	if OK != area.connect("body_entered", self, "_on_character_body_entered"):
		printerr("Enemy:Attack - unable to connect to body_entered")
		return
	if OK != area.connect("body_exited", self, "_on_character_body_exited"):
		printerr("Enemy:Attack - unable to connect to body_exited")
		return


func _update_attack_limit() -> void:
	_attack_limit = -1
	var temp = get_blackboard_data(EnemeyBaseState.BBDATA_TARGET_ATTACK_LIMIT)
	if !temp:
		return
	_attack_limit = temp
	set_blackboard_data(EnemeyBaseState.BBDATA_TARGET_ATTACK_LIMIT, null)
	temp = get_blackboard_data(EnemeyBaseState.BBDATA_TARGET_ATTACK_LIMIT_NEXT_STATE)
	if !temp:
		printerr("Attack limit but no next state??  Canceling attack limit.")
		_attack_limit = -1
		return
	_attack_limit_next_state = temp


func _on_character_body_entered(body: CollisionObject) -> void:
	if enemy.is_dead() or enemy.agression_level == GameConsts.EnemyAgressionLevel.LOW:
		return
	if _target_character or _target_destructable:
		return
	if body is Character:
		_target_character = body
		_attack_counter = 0
		change_state(name)
	elif body is Destructable:
		if body is Window and body.is_dead():
			body.queue_window_climber(enemy)
			change_state("Idle")
			return
		if body is Door and body.is_dead():
			return
		_target_destructable = body
		_attack_counter = 0
		change_state(name)


func _on_character_body_exited(body: CollisionObject) -> void:
	var target_exited := false
	if _target_character == body:
		_target_character = null
		target_exited = true
	if _target_destructable == body:
		_target_destructable = null
		target_exited = true
	if target_exited and !_target_character and !_target_destructable and state_machine.is_current_state(name):
		change_state("Walk")


func _do_damage(target) -> void:
	target.damage(enemy.damage_amount)
	emit_signal("attack_made")
	_attack_counter += 1
	if target.is_dead():
		target.is_dead()
		if target is Window:
			target.queue_window_climber(enemy)
			change_state("Idle")
			return
		change_state("Walk")
	else:
		if _attack_limit > 0 and _attack_counter >= _attack_limit:
			change_state(_attack_limit_next_state)


func do_attack_damage() -> void:
	if _target_character:
		_do_damage(_target_character)
	if _target_destructable:
		_do_damage(_target_destructable)
	

func enter() -> void:
	_update_attack_limit()
