extends StaticBody


export var time_to_complete_seconds := 10.0


onready var _progress_bar: InteractionProgressBar = $InteractionProgressBar3d

func _ready():
	_progress_bar.max_value = time_to_complete_seconds



func _on_InteractionHelper_interaction_completed(heperref, obj):
	print("Mana filled")
