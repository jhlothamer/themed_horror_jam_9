extends Node

const VOLUME_SETTINGS_FILE_PATH = "user://volume_settings.json"


var volume_settings := {}
var ignore_audio_node_additions := false

var _audio_nodes_by_scene_path := {}
var _audio_nodes_to_scene_path := {}
var _volume_settings_from_file := false


func _enter_tree():
	if !OS.has_feature("debug"):
		return
	var _results = get_tree().connect("node_added", self, "_on_node_added")
	if FileUtil.exists(VOLUME_SETTINGS_FILE_PATH):
		_volume_settings_from_file = true
		volume_settings = FileUtil.load_json_data(VOLUME_SETTINGS_FILE_PATH, volume_settings)
		_output_nodes_that_will_be_updated()


func _output_nodes_that_will_be_updated() -> void:
	pass
	for scene_path in volume_settings.keys():
		for local_path in volume_settings[scene_path].keys():
			var d: Dictionary = volume_settings[scene_path][local_path]
			if d["original_volume_db"] != d["volume_db"]:
				print("SoundLevelMgr: %s::%s will be changed from %d to %d" % [scene_path, local_path, d["original_volume_db"], d["volume_db"]])

func _get_scene_file_and_local_path(node: Node) -> Array:
	var temp = str(node.get_path())
	var local_path = str(NodePath(temp.replace(str(node.owner.get_path()), "")))
	return [node.owner.filename, local_path]


func _add_or_update_audio_node(scene_file_and_path: Array, node: Node) -> void:
	if !volume_settings.has(scene_file_and_path[0]):
		volume_settings[scene_file_and_path[0]] = {}
	var d:Dictionary = volume_settings[scene_file_and_path[0]]
	if d.has(scene_file_and_path[1]):
		var volume_db: float = d[scene_file_and_path[1]]["volume_db"]
		if node is AudioStreamPlayer:
			if _volume_settings_from_file and node.volume_db != volume_db:
				print("SoundLevelMgr: setting audio node volume from settings: %s::%s" % scene_file_and_path)
				print("\t new volume: %d" % volume_db)
			node.volume_db = volume_db
		elif node is AudioStreamPlayer2D:
			if _volume_settings_from_file and node.volume_db != volume_db:
				print("SoundLevelMgr: setting audio node volume from settings: %s::%s" % scene_file_and_path)
				print("\t new volume: %d" % volume_db)
			node.volume_db = volume_db
		elif node is AudioStreamPlayer3D:
			if _volume_settings_from_file and node.unit_db != volume_db:
				print("SoundLevelMgr: setting audio node volume from settings: %s::%s" % scene_file_and_path)
				print("\t new volume: %d" % volume_db)
			node.unit_db = volume_db
	else:
		var volume_db: float
		if node is AudioStreamPlayer:
			volume_db = node.volume_db
		elif node is AudioStreamPlayer2D:
			volume_db = node.volume_db
		elif node is AudioStreamPlayer3D:
			volume_db = node.unit_db
		d[scene_file_and_path[1]] = {"original_volume_db": volume_db, "volume_db": volume_db}
	

func _on_node_added(node : Node):
	if ignore_audio_node_additions:
		return
	if node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D:
		var scene_file_and_local_path := _get_scene_file_and_local_path(node)
		_add_or_update_audio_node(scene_file_and_local_path, node)
		var key = "%s::%s" % scene_file_and_local_path
		if !_audio_nodes_by_scene_path.has(key):
			_audio_nodes_by_scene_path[key] = []
		_audio_nodes_by_scene_path[key].append(node)
		_audio_nodes_to_scene_path[node] = key
		node.connect("tree_exited", self, "_on_audio_node_tree_exited", [node])



func _on_audio_node_tree_exited(audio_node: Node) -> void:
	var key = _audio_nodes_to_scene_path[audio_node]
	if _audio_nodes_by_scene_path.has(key):
		_audio_nodes_by_scene_path[key].erase(audio_node)


func update_volume_levels(scene_file: String, local_path: String, volume_db: float) -> void:
	var scene_file_and_path = [scene_file, local_path]
	
	if !volume_settings.has(scene_file_and_path[0]):
		volume_settings[scene_file_and_path[0]] = {}
	var d:Dictionary = volume_settings[scene_file_and_path[0]]
	if !d.has(scene_file_and_path[1]):
		d[scene_file_and_path[1]] = {"volume_db": volume_db}
	else:
		d[scene_file_and_path[1]]["volume_db"] = volume_db
	
	
	var key = "%s::%s" % scene_file_and_path
	if !_audio_nodes_by_scene_path.has(key):
		return
	
	for node in _audio_nodes_by_scene_path[key]:
		if node is AudioStreamPlayer:
			node.volume_db = volume_db
		elif node is AudioStreamPlayer2D:
			node.volume_db = volume_db
		elif node is AudioStreamPlayer3D:
			node.unit_db = volume_db


func save_volume_settings() -> void:
	FileUtil.save_json_data(VOLUME_SETTINGS_FILE_PATH, volume_settings, "\t")


func can_play_audio_node(scene_file: String, local_path: String) -> bool:
	var scene_file_and_path = [scene_file, local_path]
	var key = "%s::%s" % scene_file_and_path
	return _audio_nodes_by_scene_path.has(key) and _audio_nodes_by_scene_path[key]


func get_duplicate_audio_node(scene_file: String, local_path: String):
	var scene_file_and_path = [scene_file, local_path]
	var key = "%s::%s" % scene_file_and_path
	if !_audio_nodes_by_scene_path.has(key):
		return null
	var audio_nodes: Array = _audio_nodes_by_scene_path[key]
	if !audio_nodes:
		return null
	var audio_node:Node = _audio_nodes_by_scene_path[key][0]
	var dup = audio_node.duplicate()
	dup.stop()
	return dup
