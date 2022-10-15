extends State


export var idle_time_seconds_min := 5.0
export var idle_time_seconds_max := 20.0


var _timer := 0.0
var _curr_idle_time := 0.0


func enter() -> void:
	_curr_idle_time = rand_range(idle_time_seconds_min, idle_time_seconds_max)
	_timer = 0.0



func physics_process(delta):
	_timer += delta
	if _timer >= _curr_idle_time:
		change_state("Walk")

