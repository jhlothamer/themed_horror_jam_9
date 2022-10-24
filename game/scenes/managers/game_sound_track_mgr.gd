extends SoundTrackMgr



func stop_current_track() -> void:
	if _current_scene_sound_track != null:
		_current_scene_sound_track.stop()
