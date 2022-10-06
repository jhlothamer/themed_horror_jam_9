class_name Enemy
extends KinematicBody

signal enemy_clicked(enemy)


export var horizontal_speed = 2.0
export var disabled := false
export var damage_amount := 5.0
export var damage_interval := 2.0
export var starting_health := 30

onready var _health_bar: ProgressBar3D = $HealthBar
onready var _state_machine: StateMachine = $StateMachine
onready var _collision_shape:CollisionShape = $CollisionShape


var current_health := 100


func _ready():
	SignalMgr.register_publisher(self, "enemy_clicked")
	_health_bar.max_value = starting_health
	_health_bar.value = starting_health
	current_health = starting_health



func _on_OutlineHelper3D_clicked(_clicked_object):
	emit_signal("enemy_clicked", self)


func collide(projectile: Projectile) -> void:

	if current_health <= 0:
		return
	
	current_health = max(0, current_health - projectile.damage)
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


