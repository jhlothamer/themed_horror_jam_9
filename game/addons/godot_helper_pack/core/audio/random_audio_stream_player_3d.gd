class_name RandomAudioStreamPlayer3D
extends Spatial

signal finished()

var _streams := []
var _last_stream_played_index := -1

func _ready():
	for c in get_children():
		if c is AudioStreamPlayer or c is AudioStreamPlayer3D:
			_streams.append(c)
		if OK != c.connect("finished", self, "_on_stream_finished"):
			printerr("RandomAudioStreamPlayer3D: could not connect to finished signal: %s" % c.get_path())


func play() -> void:
	if _streams.empty():
		return
	var index = randi() % _streams.size()
	var s = _streams[index]
	var try_count := 1
	while index == _last_stream_played_index or s.playing and try_count < _streams.size():
		index = randi() % _streams.size()
		s =_streams[index]
		try_count += 1
	if s.playing:
		return
	_last_stream_played_index = index
	s.play()


func _on_stream_finished() -> void:
	emit_signal("finished")
