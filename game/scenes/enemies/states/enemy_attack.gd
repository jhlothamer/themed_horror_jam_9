extends EnemeyBaseState


signal attack_made()


export var character_detect_area: NodePath


var _target_character: Character
var _target_destructable: Destructable
var _damage_timer := 0.0


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


func _on_character_body_entered(body: CollisionObject) -> void:
	if enemy.is_dead():
		return
	if _target_character or _target_destructable:
		return
	if body is Character:
		_target_character = body
		change_state(name)
	elif body is Destructable:
		_target_destructable = body
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
		print("Switch to walk - body exited")
		change_state("Walk")


func enter() -> void:
	_damage_timer = enemy.damage_interval


func _do_damage(target) -> void:
	target.damage(enemy.damage_amount)
	emit_signal("attack_made")
	if target.is_dead():
		print("Switch to walk - target dead")
		target.is_dead()
		change_state("Walk")


func physics_process(delta) -> void:
	_damage_timer += delta
	if _damage_timer >= enemy.damage_interval:
		_damage_timer = 0.0
		if _target_character:
			_do_damage(_target_character)
		if _target_destructable:
			_do_damage(_target_destructable)


