class_name Destructable
extends StaticBody

export var starting_health := 100
export var death_sound_node_path: NodePath


onready var death_sound:AudioStreamPlayer3D = get_node_or_null(death_sound_node_path)
onready var damaged_sound:RandomAudioStreamPlayer3D = $DamagedRandomAudioStreamPlayer3D


onready var _health_bar: ProgressBar3D = $HealthBar
onready var _collision_shape: CollisionShape = $CollisionShape


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
		set_collision_layer_bit(GameConsts.PhysLayerBitIndex.DEFAULT, false)
		set_collision_mask_bit(GameConsts.PhysLayerBitIndex.DEFAULT, false)
		_on_destroid()
		return
	_on_damaged()
	damaged_sound.play()


func _update_heath_bar() -> void:
	var vis = _health_bar.value < starting_health
	_health_bar.visible = vis


func _on_damaged() -> void:
	pass


func _on_destroid() -> void:
	pass



func _on_HealthBar_completed():
	_health_bar.visible = false


func _on_HealthBar_progress_made(_new_value, _max_value):
	set_collision_layer_bit(GameConsts.PhysLayerBitIndex.DEFAULT, true)
	set_collision_mask_bit(GameConsts.PhysLayerBitIndex.DEFAULT, true)
