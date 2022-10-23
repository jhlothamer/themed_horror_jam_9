class_name DynamicMusicMgr
extends Node

export (Array, int) var intensity_level_thresholds := [0]
export (Array, NodePath) var level_audio_players := []
export var new_audio_change_time := .5
export var old_audio_change_time := 2.0
export var old_audio_change_delay_time := .5


var _level_audio_player := []
var _tween: Tween
var _current_audio_level := 0
var _audio_level_volumes := []


func _ready():
	for audio_player_node_path in level_audio_players:
		_level_audio_player.append(get_node(audio_player_node_path))
	intensity_level_thresholds.invert()
	
	SignalMgr.register_subscriber(self, "enemy_detection_area_count_changed")
	_tween = Tween.new()
	add_child(_tween)
	var mute_volume_db = _get_mute_volume_db()
	for audio_player in _level_audio_player:
		_audio_level_volumes.append(audio_player.volume_db)
		if !audio_player.autoplay:
			audio_player.volume_db = mute_volume_db
			audio_player.play()


func _get_mute_volume_db() -> float:
	return ProjectSettingsHelper.get_audio_channel_disable_threshold_db() - 5.0


func _level_from_enemy_count(enemy_count) -> int:
	var level_counter := intensity_level_thresholds.size() - 1
	for threshold_level in intensity_level_thresholds:
		if enemy_count >= threshold_level:
			return level_counter
		level_counter -= 1
	return level_counter


func _on_enemy_detection_area_count_changed(enemy_count: int) -> void:
	var new_audio_level = _level_from_enemy_count(enemy_count)
	if new_audio_level == _current_audio_level:
		return
	
	#print("DynamicMusicMgr: switching levels: enemy count: %d, old level: %d, new level: %d" % [enemy_count, _current_audio_level, new_audio_level])
	
	if _tween.is_active():
		yield(_tween, "tween_all_completed")
	
	var mute_volume_db = _get_mute_volume_db()

	var audio_player:AudioStreamPlayer
	audio_player = _level_audio_player[new_audio_level]
	if audio_player:
		if !_tween.interpolate_property(audio_player, "volume_db", mute_volume_db, _audio_level_volumes[new_audio_level], new_audio_change_time):
			printerr("DynamicMusicMgr: could not bring up volume for %s" % audio_player.get_path())

	audio_player = _level_audio_player[_current_audio_level]
	if audio_player:
		if !_tween.interpolate_property(audio_player, "volume_db", audio_player.volume_db, mute_volume_db, old_audio_change_time, Tween.TRANS_LINEAR,Tween.EASE_IN, old_audio_change_delay_time):
			printerr("DynamicMusicMgr: could not mute volume for %s" % audio_player.get_path())

	_current_audio_level = new_audio_level
	if !_tween.start():
		print("DynamicMusicMgr: could not start tween to switch audio.")













