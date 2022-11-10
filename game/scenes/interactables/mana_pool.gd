extends StaticBody


export var time_to_complete_seconds := 2.2
export var mana_given := 100


onready var _progress_bar: InteractionProgressBar = $InteractionProgressBar3d


func _ready():
	_progress_bar.max_value = time_to_complete_seconds
	_progress_bar.value = 0


func complete_interaction(interactor) -> void:
	interactor.set_resource_amount(GameConsts.RESOURCE_MANA, mana_given)
