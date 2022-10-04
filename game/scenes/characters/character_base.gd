class_name Character
extends KinematicBody


export var horizontal_speed = 4.0
export var starting_health := 100


onready var _outline_helper: OutlineHelper3D = $OutlineHelper3D
onready var _health_bar: ProgressBar3D = $HealthBar
onready var _state_machine: StateMachine = $StateMachine


var current_health := 100.0


func _ready():
	var char_mgr: CharacterMgr = ServiceMgr.get_service(CharacterMgr)
	if !char_mgr:
		return
	char_mgr.register_character(self)
	_health_bar.max_value = starting_health
	_health_bar.value = starting_health
	current_health = starting_health


func is_selected() -> bool:
	return _outline_helper.selected


func is_dead() -> bool:
	return current_health <= 0.0


func damage(amount: float) -> void:
	current_health = max(0.0, current_health - amount)
	if current_health <= 0.0:
		_state_machine.change_state("Die")
		return
	_update_heath_bar()


func _update_heath_bar() -> void:
	_health_bar.value = current_health
	_health_bar.visible = current_health < starting_health


