extends StaticBody

signal crystal_ball_status_changed(active)

onready var _active_indicator = $ActiveIndicator
onready var _active_indicator_anim_player: AnimationPlayer = $ActiveIndicator/AnimationPlayer


func _ready():
	SignalMgr.register_publisher(self, "crystal_ball_status_changed")
	_active_indicator.visible = false
	_active_indicator_anim_player.stop()


func _on_InteractionHelper_interaction_started(_interactor):
	emit_signal("crystal_ball_status_changed", true)
	_active_indicator.visible = true
	_active_indicator_anim_player.play("CircleAction001")


func _on_InteractionHelper_interaction_interrupted(_interactor):
	emit_signal("crystal_ball_status_changed", false)
	_active_indicator.visible = false
	_active_indicator_anim_player.stop()
