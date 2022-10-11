class_name Enemy
extends KinematicBody

signal enemy_clicked(enemy)


export var horizontal_speed = 2.0
export var disabled := false
export var damage_amount := 5
export var damage_interval := 2.0
export var starting_health := 30
export var debug_state := false

onready var _health_bar: ProgressBar3D = $HealthBar
onready var _state_machine: StateMachine = $StateMachine
onready var _collision_shape:CollisionShape = $CollisionShape
onready var _state_debug_label: Label3D = $StateDebugLabel3D
onready var _attack_state = $StateMachine/Attack


var current_health := 100


func _ready():
	SignalMgr.register_publisher(self, "enemy_clicked")
	_health_bar.max_value = starting_health
	_health_bar.value = starting_health
	current_health = starting_health
	_state_debug_label.visible = debug_state



func _on_OutlineHelper3D_clicked(_clicked_object):
	emit_signal("enemy_clicked", self)


func collide(projectile: Projectile) -> void:

	if current_health <= 0:
		return
	
	current_health = int(max(0, current_health - projectile.damage))
	_update_heath_bar()
	if current_health <= 0:
		_state_machine.change_state("Die")
		return
	_on_damage()


func is_dead() -> bool:
	return current_health <= 0


func _update_heath_bar() -> void:
	_health_bar.value = current_health
	_health_bar.visible = current_health < starting_health


func _disable_collisions() -> void:
	_collision_shape.disabled = true


func _on_damage():
	pass


func _death():
	pass


func _on_StateMachine_state_changed(_old_state, new_state):
	_state_debug_label.modulate = Color.from_hsv(randf(), 1.0 ,1.0, 1.0)
	_state_debug_label.text = new_state


func _do_attack_damage() -> void:
	if !_state_machine.is_current_state("Attack"):
		return
	_attack_state.do_attack_damage()


func window_climb_started() -> void:
	visible = false


func window_climb_finished(new_global_position: Vector3) -> void:
	visible = true
	global_transform.origin = new_global_position
	_state_machine.change_state("PostWindowClimb")

