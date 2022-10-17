extends EnemyWaveMgr

export var delay_between_waves_seconds := 30.0
export var initial_delay_seconds := 20.0
export (float, .0, 10.0) var per_wave_increase_amount := .2

onready var _timer: Timer = $Timer

var _enemy_spawn_counter := 1
var _enemy_increase_amount := 0.0

func _enter_tree():
	ServiceMgr.register_service(EnemyWaveMgr, self)

func _ready():
	_timer.start(initial_delay_seconds)

func _on_Timer_timeout():
	_spawn_wave(_enemy_spawn_counter)
	_enemy_increase_amount += per_wave_increase_amount
	_enemy_spawn_counter += int(floor(_enemy_increase_amount))
	_timer.start(delay_between_waves_seconds)

