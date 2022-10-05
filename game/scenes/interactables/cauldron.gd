extends StaticBody


signal game_won()


export var time_to_complete_minutes := 20.0


onready var _progress_bar: InteractionProgressBar = $InteractionProgressBar3d


func _ready():
	SignalMgr.register_publisher(self, "game_won")
	_progress_bar.max_value = time_to_complete_minutes * 60.0




func _on_InteractionHelper_interaction_completed(heperref, obj):
	emit_signal("game_won")
