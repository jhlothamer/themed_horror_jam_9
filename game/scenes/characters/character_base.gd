class_name Character
extends KinematicBody

# warning-ignore:UNUSED_SIGNAL
signal character_death_completed()


export var horizontal_speed = 4.0
export var starting_health := 100
export var death_sound_node_path: NodePath
export (Array, String) var allowed_interactable_types := []
export var debug_state := false
export var starting_resources := {}
export var invulnerable := false
export var debug_movement := false
export var can_shoot := false
export var max_mana := 100.0
export var health_regen_rate := 1.0

onready var death_sound:AudioStreamPlayer3D = get_node_or_null(death_sound_node_path)
onready var damaged_sound:RandomAudioStreamPlayer3D = $DamagedRandomAudioStreamPlayer3D

onready var _outline_helper: OutlineHelper3D = $OutlineHelper3D
onready var _health_bar: ProgressBar3D = $HealthBar
onready var _mana_bar: ProgressBar3D = $ManaBar
onready var _state_machine: StateMachine = $StateMachine
onready var _collision_shape: CollisionShape = $CollisionShape
onready var _selected_sound: AudioStreamPlayer = $SelectedSound
onready var _state_debug_label: Label3D = $StateDebugLabel3D

var current_health := 100.0

var resources := {}

func _ready():
	var char_mgr: CharacterMgr = ServiceMgr.get_service(CharacterMgr)
	if !char_mgr:
		return
	char_mgr.register_character(self)
	_health_bar.max_value = starting_health
	_health_bar.value = starting_health
	current_health = starting_health
	_state_debug_label.visible = debug_state
	resources = starting_resources.duplicate(true)
	_mana_bar.max_value = max_mana
	_mana_bar.value = 0.0


func is_selected() -> bool:
	return _outline_helper.selected


func is_dead() -> bool:
	return current_health <= 0.0


func damage(amount: float) -> void:
	if invulnerable or current_health <= 0.0:
		return
	
	current_health = max(0.0, current_health - amount)
	_update_heath_bar()
	if current_health <= 0.0:
		_collision_shape.disabled = true
		_state_machine.change_state("Die")
		return
	damaged_sound.play()


func _update_heath_bar() -> void:
	_health_bar.value = current_health
	_health_bar.visible = current_health < starting_health

func _update_mana_bar() -> void:
	if !resources.has(GameConsts.RESOURCE_MANA):
		return
	_mana_bar.visible = true
	_mana_bar.value = resources[GameConsts.RESOURCE_MANA]


func _on_OutlineHelper3D_selected(_helperref):
	if !_selected_sound.is_playing():
		_selected_sound.play()


func _on_StateMachine_state_changed(_old_state, new_state):
	_state_debug_label.text = new_state


func set_resource_amount(resource_name: String, resource_amount: int) -> void:
	resources[resource_name] = resource_amount
	if resource_name == GameConsts.RESOURCE_MANA:
		_update_mana_bar()


func has_required_resource_amount(resource_name: String, resource_amount: int) -> bool:
	if resources.has(resource_name):
		return resources[resource_name] >= resource_amount
	return false


func decrease_resource_amount(resource_name: String, resource_amount: int) -> void:
	if !resources.has(resource_name):
		return
	resources[resource_name] = max(0, resources[resource_name] - resource_amount)
	if resource_name == GameConsts.RESOURCE_MANA:
		_update_mana_bar()


func _physics_process(delta):
	if _health_bar.value >= _health_bar.max_value:
		return
	_health_bar.value = min(_health_bar.max_value, _health_bar.value + delta * health_regen_rate)
	if _health_bar.value >= _health_bar.max_value:
		_health_bar.visible = false
