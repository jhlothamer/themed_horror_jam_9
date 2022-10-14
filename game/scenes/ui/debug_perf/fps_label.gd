class_name FPSLabel
extends Label


enum MonitorType {
	FPS,
	FPS_MAX,
	FPS_MIN,
	FPS_AVG
}

export var prefix := ""
export (MonitorType) var monitor_type: int

var _count := 0
var _total := 0.0
var _max := -1.0
var _min := INF
var _throw_away_counter := 300


func _process(_delta : float) -> void:
	var fps: float = Performance.get_monitor(Performance.TIME_FPS)
	var value: float = 0.0
	match(monitor_type):
		MonitorType.FPS:
			value = fps
		MonitorType.FPS_MAX:
			_max = max(_max, fps)
			value = _max
		MonitorType.FPS_MIN:
			if _throw_away_counter > 0:
				_throw_away_counter -= 1
			else:
				_min = min(_min, fps)
				value = _min
		MonitorType.FPS_AVG:
			if _throw_away_counter > 0:
				_throw_away_counter -= 1
			else:
				_count += 1
				_total += fps
				if _count == 0:
					value = NAN
					_total = 0.0
				else:
					value = _total / _count
		_:
			value = NAN

	text = prefix + "%.2d" % value


