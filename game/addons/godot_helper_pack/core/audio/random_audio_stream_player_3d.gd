class_name RandomAudioStreamPlayer3D
extends Spatial

var _streams := []

func _ready():
	for c in get_children():
		if c is AudioStreamPlayer or c is AudioStreamPlayer3D:
			_streams.append(c)


func play() -> void:
	if _streams.empty():
		return
	var index = randi() % _streams.size()
	var s = _streams[index]
	var try_count := 1
	while s.playing and try_count < _streams.size():
		index = randi() % _streams.size()
		s =_streams[index]
		try_count += 1
	if s.playing:
		return
	s.play()
	
