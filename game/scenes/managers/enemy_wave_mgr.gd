class_name EnemyWaveMgr
extends Node

export var delay_between_spawns_min := 1.0
export var delay_between_spawns_max := 5.0
export var delay_between_waves_seconds := 30.0
export var initial_delay_seconds := 30.0
export var disabled := false
export (float, .0, 10.0) var per_wave_increase_amount := .3

onready var _timer: Timer = $Timer

var _enemy_spawn_counter := 1
var _enemy_increase_amount := 0.0

func _enter_tree():
	ServiceMgr.register_service(get_script(), self)

func _ready():
	_timer.start(initial_delay_seconds)

func _on_Timer_timeout():
	_spawn_wave()
	_timer.start(delay_between_waves_seconds)

func _spawn_wave() -> void:
	if disabled:
		return
	var spawn_mgr:EnemySpawnMgr = ServiceMgr.get_service(EnemySpawnMgr)
	for i in _enemy_spawn_counter:
		spawn_mgr.spawn_enemy()
		yield(get_tree().create_timer(rand_range(delay_between_spawns_min, delay_between_spawns_max)), "timeout")
	_enemy_increase_amount += per_wave_increase_amount
	_enemy_spawn_counter += int(floor(_enemy_increase_amount))
