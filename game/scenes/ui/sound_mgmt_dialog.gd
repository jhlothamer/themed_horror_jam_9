extends Control

enum TreeColumns {
	PATH,
	VOLUME_DB,
}

onready var _tree: Tree = $MarginContainer/VBoxContainer/Control/Tree

func _ready():
	visible = false
	if !OS.has_feature("debug"):
		queue_free()


func _input(event):
	if event.is_action_pressed("sound_dialog") and !visible:
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
			data_tree_node.set_cell_mode(TreeColumns.VOLUME_DB, TreeItem.CELL_MODE_RANGE)
			data_tree_node.set_range_config(TreeColumns.VOLUME_DB, -60.0, 24.0, .1)
			data_tree_node.set_range(TreeColumns.VOLUME_DB, volume_db)
			data_tree_node.set_editable(TreeColumns.VOLUME_DB, true)
			data_tree_node.set_metadata(TreeColumns.VOLUME_DB, volume_db)


func _on_CancelBtn_pressed():
	visible = false
	get_tree().paused = false
	pause_mode = Node.PAUSE_MODE_STOP


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

