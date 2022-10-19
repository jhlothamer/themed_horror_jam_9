extends EnemyWaveMgr


class ScheduleItem:
	var time_seconds: float
	var enemy_count: int
	var mode: int
	func _init(csv_line: PoolStringArray) -> void:
		time_seconds = float(csv_line[0])
		enemy_count = int(csv_line[1])
		var temp = csv_line[2].to_upper()
		if GameConsts.EnemyAgressionLevel.has(temp):
			mode = GameConsts.EnemyAgressionLevel[temp]


export (String, FILE, "*.txt") var schedule_file_csv: String = "res://assets/data/enemy_wave_schedule.txt"
export var alt_schedule_file_csv: String ="user://enemy_wave_schedule.csv"

onready var _timer: Timer = $Timer


var _schedule := []
var _schedule_index := 0
var _previous_wave_time := 0.0


func _ready():
	_read_schedule()
	_schedule_next_wave()


func _read_schedule() -> void:
	var file = File.new()
	
	var file_path := ""
	if file.file_exists(alt_schedule_file_csv):
		file_path = alt_schedule_file_csv
		print("*** using %s schedule file ***" % alt_schedule_file_csv)
	if file_path == "" and !file.file_exists(schedule_file_csv):
		printerr("ScheduledEnemyWaveMgr: schedule file does not exist: %s" % schedule_file_csv)
		return
	else:
		file_path = schedule_file_csv
	
	if OK != file.open(file_path,File.READ):
		printerr("ScheduledEnemyWaveMgr: could not open schedule file: %s" % schedule_file_csv)
		return
	var _headers = file.get_csv_line()
	while !file.eof_reached():
		var csv = file.get_csv_line()
		if !csv or csv.size() < 3:
			continue
		_schedule.append(ScheduleItem.new(csv))
	file.close()


func _schedule_next_wave() -> void:
	if disabled or _schedule_index >= _schedule.size():
		return
	
	var schedule_item: ScheduleItem = _schedule[_schedule_index]
	_timer.start(schedule_item.time_seconds - _previous_wave_time)
	_previous_wave_time = schedule_item.time_seconds


func _on_Timer_timeout():
	var schedule_item: ScheduleItem = _schedule[_schedule_index]
	_spawn_wave(schedule_item.enemy_count, schedule_item.mode)
	_schedule_index += 1
	_schedule_next_wave()




