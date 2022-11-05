class_name InteractionHelper
extends Node

enum InteractionProgressType {
	SINGLE,		# one progress bar, multiple interactors allowed
	MULTIPLE,	# separate progress bars per interactor
	EXCLUSIVE,	# one interactor allowed at a time
	NONE,		# no progress - interaction never completes
}


signal interactable_clicked(helperref ,obj)
signal interaction_completed(helperref, obj, interactor)
signal interaction_started(interactor)
signal interaction_interrupted(interactor)
signal interaction_completion_began()


export var outline_helper: NodePath
export var interaction_progress_bar: NodePath
export var interactable_type := ""
export var interaction_start_sound: NodePath
export var interaction_interrupt_sound: NodePath
export var interaction_complete_sound: NodePath
export var complete_after_complete_sound_finished := true
export var required_resource_type := ""
export (int, 1, 10000) var required_resource_amount := 1
export var delay_completion_seconds := 0.0
export (InteractionProgressType) var interaction_progress_type: int
export var allowed_type_deny_message := ""
export var required_resource_deny_message := ""

onready var _parent: CollisionObject = get_parent()
onready var _interaction_start_sound = get_node_or_null(interaction_start_sound)
onready var _interaction_interrupt_sound = get_node_or_null(interaction_interrupt_sound)
onready var _interaction_complete_sound = get_node_or_null(interaction_complete_sound)


var _interaction_progress_bar: InteractionProgressBar
var _interactor_counter := 0
var _interactor_progress_bars := {}
var _interactor_sounds := {}


func _ready():
	var helper: OutlineHelper3D = get_node(outline_helper)
	if !helper:
		printerr("InteractionHelper: bad outline helper node path")
		return
	
	if OK != helper.connect("clicked", self, "_on_clicked"):
		printerr("InteractionHelper: could not connect to clicked signal of outline helper.")
		return
	
	_interaction_progress_bar = get_node_or_null(interaction_progress_bar)
	if _interaction_progress_bar:
		if OK != _interaction_progress_bar.connect("completed", self, "_on_interaction_completed"):
			printerr("InteractionHelper: could not connect to completed signal of interaction progress bar.")
			return
	elif interaction_progress_type != InteractionProgressType.NONE:
		printerr("InteractionHelper: progress type not set to NONE.  Need interaction progress bar.")
	
	SignalMgr.register_publisher(self, "interactable_clicked")
	SignalMgr.register_publisher(self, "interaction_completed")


func _on_clicked(_clicked_object) -> void:
	emit_signal("interactable_clicked", self, _parent)


func _add_interactor_sound(interactor, sound) -> void:
	_remove_interactor_sound(interactor)

	var interactor_sound = sound.duplicate()
	_parent.add_child(interactor_sound)
	if OK != interactor_sound.connect("finished", self, "_on_interactor_sound_finished", [interactor, sound]):
		printerr("InteractionHelper: count not connect to finished signal for sound %s" % sound.get_path())
		return
	interactor_sound.play()
	_interactor_sounds[interactor] = interactor_sound


func _remove_interactor_sound(interactor) -> void:
	if !_interactor_sounds.has(interactor):
		return
	_interactor_sounds[interactor].stop()
	_interactor_sounds[interactor].queue_free()
	var _discard = _interactor_sounds.erase(interactor)
	if _interactor_sounds.has(interactor):
		breakpoint


func _single_start_interaction(interactor) -> void:
	if _interaction_progress_bar:
		_interaction_progress_bar.start()
	_interactor_counter += 1
	if _interactor_counter == 1 and _interaction_start_sound and !_interaction_start_sound.is_playing():
		_interaction_start_sound.play()
	emit_signal("interaction_started", interactor)


func _multiple_start_interaction(interactor: Spatial) -> void:
	var interactor_progress_bar = _interaction_progress_bar.duplicate(DUPLICATE_GROUPS | DUPLICATE_SCRIPTS | DUPLICATE_USE_INSTANCING)
	_parent.add_child(interactor_progress_bar)
	if OK != interactor_progress_bar.connect("completed", self, "_on_interactor_interaction_complete", [interactor]):
		printerr("InteractionHelper: count connect to progress bar completed signal for %s" % interactor_progress_bar.get_path())
		interactor_progress_bar.queue_free()
		return
	interactor_progress_bar.global_translation = (_interaction_progress_bar.global_translation + interactor.global_translation) / 2.0
	interactor_progress_bar.start()
	_interactor_progress_bars[interactor] = interactor_progress_bar
	
	if _interaction_start_sound:
		_add_interactor_sound(interactor, _interaction_start_sound)


func _exclusive_start_interaction(interactor) -> void:
	if _interactor_counter > 0:
		return
	_single_start_interaction(interactor)


func _none_start_interaction(interactor) -> void:
	if _interaction_start_sound and !_interaction_start_sound.is_playing():
		_interaction_start_sound.play()
	emit_signal("interaction_started", interactor)


func start_interaction(interactor) -> void:
	match interaction_progress_type:
		InteractionProgressType.SINGLE:
			_single_start_interaction(interactor)
		InteractionProgressType.MULTIPLE:
			_multiple_start_interaction(interactor)
		InteractionProgressType.EXCLUSIVE:
			_exclusive_start_interaction(interactor)
		InteractionProgressType.NONE:
			_single_start_interaction(interactor)


func _single_stop_interaction(interactor) -> void:
	if _interactor_counter <= 0:
		return
	
	_interactor_counter -= 1
	
	if _interactor_counter > 0:
		return
	
	if _interaction_progress_bar:
		_interaction_progress_bar.stop()
	
	if _interaction_start_sound and _interaction_start_sound.is_playing():
		_interaction_start_sound.stop()
	
	if _interaction_interrupt_sound and !_interaction_interrupt_sound.is_playing():
		_interaction_interrupt_sound.play()
	
	emit_signal("interaction_interrupted", interactor)


func _multiple_stop_interaction(interactor) -> void:
	if !_interactor_progress_bars.has(interactor):
		return
	var interactor_progress_bar = _interactor_progress_bars[interactor]
	interactor_progress_bar.queue_free()
	var _discard = _interactor_progress_bars.erase(interactor)
	if _interaction_start_sound and _interaction_start_sound.is_playing():
		breakpoint
	if _interaction_interrupt_sound:
		_add_interactor_sound(interactor, _interaction_interrupt_sound)


func _none_stop_interaction(interactor) -> void:
	_interactor_counter -= 1

	if _interaction_start_sound and _interaction_start_sound.is_playing():
		_interaction_start_sound.stop()
	
	if _interaction_interrupt_sound and !_interaction_interrupt_sound.is_playing():
		_interaction_interrupt_sound.play()
	emit_signal("interaction_interrupted", interactor)


func stop_interaction(interactor) -> void:
	match interaction_progress_type:
		InteractionProgressType.SINGLE, InteractionProgressType.EXCLUSIVE:
			_single_stop_interaction(interactor)
		InteractionProgressType.MULTIPLE:
			_multiple_stop_interaction(interactor)
		InteractionProgressType.NONE:
			_none_stop_interaction(interactor)


func _on_interaction_completed() -> void:
	
	emit_signal("interaction_completion_began")
	
	if delay_completion_seconds > 0.0:
		yield(get_tree().create_timer(delay_completion_seconds), "timeout")
	
	if _interaction_start_sound and _interaction_start_sound.is_playing():
		_interaction_start_sound.stop()
	
	if _interaction_complete_sound and !_interaction_complete_sound.is_playing():
		_interaction_complete_sound.play()
		if complete_after_complete_sound_finished:
			yield(_interaction_complete_sound, "finished")
	
	emit_signal("interaction_completed", self, _parent, null)
	
	if _interaction_progress_bar:
		_interaction_progress_bar.reset()


func _on_interactor_interaction_complete(interactor) -> void:
	if !_interactor_progress_bars.has(interactor):
		return

	var interactor_progress_bar = _interactor_progress_bars[interactor]
	interactor_progress_bar.queue_free()
	var _discard = _interactor_progress_bars.erase(interactor)

	emit_signal("interaction_completed", self, _parent, interactor)

	if _interaction_complete_sound:
		_add_interactor_sound(interactor, _interaction_complete_sound)
	_parent.complete_interaction(interactor)


func _on_interactor_sound_finished(interactor, _sound) -> void:
	_remove_interactor_sound(interactor)
