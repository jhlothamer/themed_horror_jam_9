class_name InteractionHelper
extends Node


signal interactable_clicked(helperref ,obj)
signal interaction_completed(helperref, obj)


export var outline_helper: NodePath
export var interaction_progress_bar: NodePath
export var interactable_type := ""
export var interaction_start_sound: NodePath
export var interaction_interupt_sound: NodePath
export var interaction_complete_sound: NodePath
export var complete_after_complete_sound_finished := true

onready var _parent: CollisionObject = get_parent()
onready var _interaction_start_sound: AudioStreamPlayer3D = get_node_or_null(interaction_start_sound)
onready var _interaction_interupt_sound: AudioStreamPlayer3D = get_node_or_null(interaction_interupt_sound)
onready var _interaction_complete_sound: AudioStreamPlayer3D = get_node_or_null(interaction_complete_sound)


var _interaction_progress_bar: InteractionProgressBar
var _interactor_counter := 0



func _ready():
	var helper: OutlineHelper3D = get_node(outline_helper)
	if !helper:
		printerr("InteractionHelper: bad outline helper node path")
		return
	
	if OK != helper.connect("clicked", self, "_on_clicked"):
		printerr("InteractionHelper: could not connect to clicked signal")
		return
	
	_interaction_progress_bar = get_node(interaction_progress_bar)
	if !_interaction_progress_bar:
		printerr("InteractionHelper: bad interaction progress bar node path")
		return
	if OK != _interaction_progress_bar.connect("completed", self, "_on_interaction_completed"):
		printerr("InteractionHelper: could not connect to completed signal")
		return
	
	SignalMgr.register_publisher(self, "interactable_clicked")
	SignalMgr.register_publisher(self, "interaction_completed")


func _on_clicked(_clicked_object) -> void:
	emit_signal("interactable_clicked", self, _parent)


func start_interaction() -> void:
	_interaction_progress_bar.start()
	_interactor_counter += 1
	if _interactor_counter == 1 and _interaction_start_sound and !_interaction_start_sound.is_playing():
		_interaction_start_sound.play()
	

func stop_interaction() -> void:
	_interactor_counter -= 1
	if _interactor_counter <= 0:
		_interaction_progress_bar.stop()
	if _interaction_start_sound and _interaction_start_sound.is_playing():
		_interaction_start_sound.stop()
		if _interaction_interupt_sound and !_interaction_interupt_sound.is_playing():
			_interaction_interupt_sound.play()


func _on_interaction_completed() -> void:
	if _interaction_start_sound and _interaction_start_sound.is_playing():
		_interaction_start_sound.stop()
	if _interaction_complete_sound and !_interaction_complete_sound.is_playing():
		_interaction_complete_sound.play()
		if complete_after_complete_sound_finished:
			yield(_interaction_complete_sound, "finished")
	emit_signal("interaction_completed", self, _parent)
	_interaction_progress_bar.reset()
