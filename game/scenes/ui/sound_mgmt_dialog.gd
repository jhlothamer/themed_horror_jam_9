extends Control

enum TreeColumns {
	PATH,
	PLAY_BTN,
	VOLUME_DB,
}


onready var _tree: Tree = $MarginContainer/VBoxContainer/Control/Tree
onready var _play_btn_texture: Texture = $PlayBtnTextureRect.texture

var _duplicated_audio_nodes := {}

func _ready():
	visible = false
	if !OS.has_feature("debug"):
		queue_free()


func _input(event):
	if event.is_action_pressed("sound_dialog") and !visible:
		SoundLevelMgr.ignore_audio_node_additions = true
		visible = true
		pause_mode = Node.PAUSE_MODE_PROCESS
		get_tree().paused = true
		_tree.grab_focus()
		_refresh_list()


func _refresh_list():
	_tree.clear()
	var root = _tree.create_item()
	var child_scene_file_names: Array = SoundLevelMgr.volume_settings.keys()
	child_scene_file_names.sort()
	for child_scene_file_name in child_scene_file_names:
		var owner_tree_node := _tree.create_item(root)
		owner_tree_node.set_text(TreeColumns.PATH, child_scene_file_name)
		owner_tree_node.collapsed = true
		var local_paths: Array = SoundLevelMgr.volume_settings[child_scene_file_name].keys()
		local_paths.sort()
		for local_path in local_paths:
			var volume_db: float = SoundLevelMgr.volume_settings[child_scene_file_name][local_path]["volume_db"]
			var data_tree_node := _tree.create_item(owner_tree_node)
			data_tree_node.set_text(TreeColumns.PATH, local_path)
#			data_tree_node.set_expand_right(TreeColumns.PATH, true)
#			data_tree_node.set_expand_right(TreeColumns.PLAY_BTN, false)
#			data_tree_node.set_expand_right(TreeColumns.VOLUME_DB, false)
			
			data_tree_node.set_cell_mode(TreeColumns.VOLUME_DB, TreeItem.CELL_MODE_RANGE)
			data_tree_node.set_range_config(TreeColumns.VOLUME_DB, -60.0, 24.0, .1)
			data_tree_node.set_range(TreeColumns.VOLUME_DB, volume_db)
			data_tree_node.set_editable(TreeColumns.VOLUME_DB, true)
			data_tree_node.set_metadata(TreeColumns.VOLUME_DB, volume_db)
			if SoundLevelMgr.can_play_audio_node(child_scene_file_name, local_path):
				data_tree_node.add_button(TreeColumns.PLAY_BTN, _play_btn_texture, 0)


func _on_CancelBtn_pressed():
	visible = false
	get_tree().paused = false
	pause_mode = Node.PAUSE_MODE_STOP
	_cleanup_duplicate_audio_nodes()
	SoundLevelMgr.ignore_audio_node_additions = false


func _on_OKBtn_pressed():
	_apply_changes()
	_on_CancelBtn_pressed()


func _apply_changes() -> void:
	var root = _tree.get_root()
	var scene_file_tree_node:TreeItem = root.get_children()
	while scene_file_tree_node:
		var scene_file: String = scene_file_tree_node.get_text(TreeColumns.PATH)
		var local_path_tree_node: TreeItem = scene_file_tree_node.get_children()
		while local_path_tree_node:
			var local_path: String = local_path_tree_node.get_text(TreeColumns.PATH)
			var original_volume_db: float = local_path_tree_node.get_metadata(TreeColumns.VOLUME_DB)
			var volume_db = local_path_tree_node.get_range(TreeColumns.VOLUME_DB)
			if volume_db != original_volume_db:
				print("Updateing volume: %d -> %d for %s::%s" % [original_volume_db, volume_db, scene_file, local_path])
				SoundLevelMgr.update_volume_levels(scene_file, local_path, volume_db)
			local_path_tree_node = local_path_tree_node.get_next()
		scene_file_tree_node = scene_file_tree_node.get_next()


func _on_SaveBtn_pressed():
	SoundLevelMgr.save_volume_settings()


func _on_Tree_button_pressed(item:TreeItem, _column: int, _id: int) -> void:
	var parent_item := item.get_parent()
	var scene_file: String = parent_item.get_text(TreeColumns.PATH)
	var local_path: String = item.get_text(TreeColumns.PATH)
	
	var key = "%s::%s" % [scene_file, local_path]
	var audio_node
	if !_duplicated_audio_nodes.has(key):
		audio_node = SoundLevelMgr.get_duplicate_audio_node(scene_file, local_path)
		_duplicated_audio_nodes[key] = audio_node
		audio_node.stream_paused = false
		add_child(_duplicated_audio_nodes[key])
	else:
		audio_node = _duplicated_audio_nodes[key]
	var volume_db = item.get_range(TreeColumns.VOLUME_DB)
	if audio_node is AudioStreamPlayer3D:
		audio_node.unit_db = volume_db
	else:
		audio_node.volume_db = volume_db
	
	print("Playing %s" % [key])
	audio_node.play()


func _cleanup_duplicate_audio_nodes() -> void:
	for audio_node in _duplicated_audio_nodes.values():
		audio_node.queue_free()
	_duplicated_audio_nodes.clear()
