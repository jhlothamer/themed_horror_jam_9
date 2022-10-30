extends StaticBody

export var time_to_complete_seconds := 10.0
export var resource_given := 100


onready var _progress_bar: InteractionProgressBar = $InteractionProgressBar3d


func _ready():
	_progress_bar.max_value = time_to_complete_seconds


func complete_interaction(interactor) -> void:
	interactor.set_resource_amount(GameConsts.RESOURCE_WOOD, resource_given)
