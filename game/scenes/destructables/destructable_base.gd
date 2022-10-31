class_name Destructable
extends StaticBody


export var starting_health := 100
export var death_sound_node_path: NodePath
export var disable_collision_on_destroy := true


onready var death_sound:AudioStreamPlayer3D = get_node_or_null(death_sound_node_path)
onready var damaged_sound:RandomAudioStreamPlayer3D = $DamagedRandomAudioStreamPlayer3D


onready var _health_bar: ProgressBar3D = $HealthBar
onready var _collision_shape: CollisionShape = $CollisionShape
onready var _interaction_helper: InteractionHelper = $InteractionHelper
onready var _enemy_agression_change_trigger = $EnemyAgressionChangeArea

var _current_interactor: Character


func _ready():
	_health_bar.max_value = starting_health
	_health_bar.value = starting_health


func is_dead() -> bool:
	return _health_bar.value <= 0.0


func damage(amount: float) -> void:
	if _health_bar.value <= 0.0:
		return
	
	_health_bar.value = max(0.0, _health_bar.value - amount)
	_update_heath_bar()
	if _health_bar.value <= 0.0:
		if disable_collision_on_destroy:
			set_collision_layer_bit(GameConsts.PhysLayerBitIndex.DEFAULT, false)
			set_collision_mask_bit(GameConsts.PhysLayerBitIndex.DEFAULT, false)
		_on_destroid()
		return
	_on_damaged()
	damaged_sound.play()


func can_interact(_interactor) -> bool:
	return _health_bar.value < _health_bar.max_value


func get_deny_message(_interactor) -> String:
	if _health_bar.value == _health_bar.max_value:
		return "No repair currently needed"
	return ""


func _update_heath_bar() -> void:
	_health_bar.visible = _health_bar.value < starting_health


func _on_damaged() -> void:
	pass


func _on_destroid() -> void:
	pass



func _on_HealthBar_completed():
	_health_bar.visible = false


func _on_HealthBar_progress_made(_new_value, _max_value):
	set_collision_layer_bit(GameConsts.PhysLayerBitIndex.DEFAULT, true)
	set_collision_mask_bit(GameConsts.PhysLayerBitIndex.DEFAULT, true)


func _on_InteractionHelper_interaction_completed(_helperref, _obj, _interactor):
	if _current_interactor and _interaction_helper.required_resource_type != "":
		_current_interactor.decrease_resource_amount(_interaction_helper.required_resource_type, _interaction_helper.required_resource_amount)
		_current_interactor = null


func _on_InteractionHelper_interaction_started(interactor):
	if !_current_interactor:
		_current_interactor = interactor


func _on_InteractionHelper_interaction_interrupted(interactor):
	if _current_interactor == interactor:
		_current_interactor = null


func _on_HealthBar_value_changed(new_value: float) -> void:
	_enemy_agression_change_trigger.active = new_value <= 0.0

