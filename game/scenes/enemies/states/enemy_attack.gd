extends EnemeyBaseState


export var character_detect_area: NodePath


var _target_character: Character
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
	if !body is Character:
		return
	if !_target_character:
		_target_character = body
		change_state(name)
		if _target_character.is_dead():
			_target_character = null
			change_state("Walk")


func _on_character_body_exited(body: CollisionObject) -> void:
	if _target_character == body:
		_target_character = null
		change_state("Walk")


func enter() -> void:
	_damage_timer = 0.0


func physics_process(delta) -> void:
	_damage_timer += delta
	if _damage_timer >= enemy.damage_interval:
		_target_character.damage(enemy.damage_amount)
		_damage_timer = 0.0


