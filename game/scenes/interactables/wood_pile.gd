extends StaticBody

export var time_to_complete_seconds := 10.0
export var resource_given := 100


onready var _progress_bar: InteractionProgressBar = $InteractionProgressBar3d

var _current_interactor: Character


func _ready():
	_progress_bar.max_value = time_to_complete_seconds


func _on_InteractionHelper_interaction_started(interactor):
	if !_current_interactor:
		_current_interactor = interactor


func _on_InteractionHelper_interaction_interrupted(interactor):
	if _current_interactor == interactor:
		_current_interactor = null


func _on_InteractionHelper_interaction_completed(_helperref, _obj):
	if !_current_interactor:
		return
	_current_interactor.set_resource_amount(GameConsts.RESOURCE_WOOD, resource_given)
	_current_interactor = null
