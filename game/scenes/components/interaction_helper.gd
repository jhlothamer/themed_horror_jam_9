class_name InteractionHelper
extends Node


signal interactable_clicked(helperref ,obj)
signal interaction_completed(heperref, obj)


export var outline_helper: NodePath
export var interaction_progress_bar: NodePath


onready var _parent: CollisionObject = get_parent()


var _interaction_progress_bar: InteractionProgressBar
var _interactor_counter := 0


func _ready():
	var helper: OutlineHelper3D = get_node(outline_helper)
	if !helper:
		printerr("bad outline helper node path")
		return
	helper.connect("clicked", self, "_on_clicked")
	
	_interaction_progress_bar = get_node(interaction_progress_bar)
	if !_interaction_progress_bar:
		printerr("bad interaction progress bar node path")
		return
	_interaction_progress_bar.connect("completed", self, "_on_interaction_completed")
	
	SignalMgr.register_publisher(self, "interactable_clicked")
	SignalMgr.register_publisher(self, "interaction_completed")


func _on_clicked(_clicked_object) -> void:
	emit_signal("interactable_clicked", self, _parent)


func start_interaction() -> void:
	_interaction_progress_bar.start()
	_interactor_counter += 1
	

func stop_interaction() -> void:
	_interactor_counter -= 1
	if _interactor_counter <= 0:
		_interaction_progress_bar.stop()


func _on_interaction_completed() -> void:
	emit_signal("interaction_completed", self, _parent)
	_interaction_progress_bar.reset()
