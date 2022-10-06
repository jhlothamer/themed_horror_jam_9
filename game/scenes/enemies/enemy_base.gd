class_name Enemy
extends KinematicBody

signal enemy_clicked(enemy)


export var horizontal_speed = 2.0
export var disabled := false
export var damage_amount := 5.0
export var damage_interval := 2.0
export var starting_health := 30

onready var _health_bar: ProgressBar3D = $HealthBar


var current_health := 100.0


func _ready():
	SignalMgr.register_publisher(self, "enemy_clicked")
	_health_bar.max_value = starting_health
	_health_bar.value = starting_health
	current_health = starting_health



func _on_OutlineHelper3D_clicked(_clicked_object):
	emit_signal("enemy_clicked", self)


func collide(projectile: Projectile) -> void:

	if current_health <= 0.0:
		return
	
	current_health = max(0.0, current_health - projectile.damage)
	if current_health <= 0.0:
		queue_free()
		return
	
	_update_heath_bar()


func _update_heath_bar() -> void:
	_health_bar.value = current_health
	_health_bar.visible = current_health < starting_health


