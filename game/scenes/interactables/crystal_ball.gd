extends StaticBody

signal crystal_ball_status_changed(active)

func _ready():
	SignalMgr.register_publisher(self, "crystal_ball_status_changed")


func _on_InteractionHelper_interaction_started():
	emit_signal("crystal_ball_status_changed", true)


func _on_InteractionHelper_interaction_interrupted():
	emit_signal("crystal_ball_status_changed", false)
