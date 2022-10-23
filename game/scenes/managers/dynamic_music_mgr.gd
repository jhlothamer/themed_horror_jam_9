class_name DynamicMusicMgr
extends Node

export var level_1_enemy_count := 1
export var level_2_enemy_count := 3
export var level_3_enemy_count := 5
export (NodePath) var level_1_audio_player
export (NodePath) var level_2_audio_player
export (NodePath) var level_3_audio_player
export var new_audio_change_time := .5
export var old_audio_change_time := .5
export var old_audio_change_delay_time := 1.0


onready var _level_audio_player := [
	null, # no audio at level 0
	get_node(level_1_audio_player),
	get_node(level_2_audio_player),
	get_node(level_3_audio_player),
]

var _tween: Tween
var _current_audio_level := 0
var _audio_level_volumes := []

func _ready():
	SignalMgr.register_subscriber(self, "enemy_detection_area_count_changed")
	_tween = Tween.new()
	add_child(_tween)
	var mute_volume_db = _get_mute_volume_db()
	for audio_player in _level_audio_player:
		if audio_player:
			_audio_level_volumes.append(audio_player.volume_db)
			audio_player.volume_db = mute_volume_db
			audio_player.play()
		else:
			_audio_level_volumes.append(0)


func _get_mute_volume_db() -> float:
	return ProjectSettingsHelper.get_audio_channel_disable_threshold_db() - 5.0


func _level_from_enemy_count(enemy_count) -> int:
	if enemy_count >= level_3_enemy_count:
		return 3
	if enemy_count >= level_2_enemy_count:
		return 2
	if enemy_count >= level_1_enemy_count:
		return 1
	return 0


func _on_enemy_detection_area_count_changed(enemy_count: int) -> void:
	var new_audio_level = _level_from_enemy_count(enemy_count)
	if new_audio_level == _current_audio_level:
		return
	
	print("DynamicMusicMgr: switching levels: enemy count: %d, old level: %d, new level: %d" % [enemy_count, _current_audio_level, new_audio_level])
	
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













