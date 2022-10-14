extends StaticBody


export var time_to_complete_seconds := 2.2
export var mana_given := 100


onready var _progress_bar: InteractionProgressBar = $InteractionProgressBar3d


var _current_interactors := []


func _ready():
	_progress_bar.max_value = time_to_complete_seconds
	_progress_bar.value = 0


func _on_InteractionHelper_interaction_completed(_helperref, _obj):
	for i in _current_interactors:
		i.set_resource_amount(GameConsts.RESOURCE_MANA, mana_given)
	_current_interactors.clear()


func _on_InteractionHelper_interaction_started(interactor):
	if !_current_interactors.has(interactor):
		_current_interactors.append(interactor)


func _on_InteractionHelper_interaction_interrupted(interactor):
	_current_interactors.erase(interactor)
