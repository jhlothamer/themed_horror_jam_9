extends StaticBody


signal crystal_ball_status_changed(active)


onready var _active_indicator = $ActiveIndicator
onready var _active_indicator_anim_player: AnimationPlayer = $ActiveIndicator/AnimationPlayer
onready var _ward_activated_sound: AudioStreamPlayer = $WardActivatedSound
onready var _ward_deactivated_sound: AudioStreamPlayer = $WardDeactivatedSound


var _instructions_shown := true


func _ready():
	_active_indicator.visible = false
	_active_indicator_anim_player.stop()
	SignalMgr.register_publisher(self, "crystal_ball_status_changed")
	SignalMgr.register_subscriber(self, "ward_activated")
	SignalMgr.register_subscriber(self, "ward_deactivated")


func _on_InteractionHelper_interaction_started(_interactor):
	emit_signal("crystal_ball_status_changed", true)
	if _instructions_shown:
		return
	_instructions_shown = true
	var hud: HUD = ServiceMgr.get_service(HUD)
	hud.add_message(InputPromptUtil.replace_input_prompts("Switch crystal ball view with [%%prompt:key:0:previous_camera%%] [%%prompt:key:0:next_camera%%] or [%%prompt:key:1:previous_camera%%] [%%prompt:key:1:next_camera%%]", InputPromptUtil.PromptImageSize.MEDIUM ))
	hud.add_message(InputPromptUtil.replace_input_prompts("Cast ward with [ %%prompt:key:0:place_ward%% ] to ward off 5 zombies in that direction.", InputPromptUtil.PromptImageSize.MEDIUM))


func _on_InteractionHelper_interaction_interrupted(_interactor):
	emit_signal("crystal_ball_status_changed", false)


func _on_ward_activated():
	_active_indicator.visible = true
	_active_indicator_anim_player.play("CircleAction001")
	_ward_activated_sound.play()


func _on_ward_deactivated():
	_active_indicator.visible = false
	_active_indicator_anim_player.stop()
	_ward_deactivated_sound.play()
	var hud: HUD = ServiceMgr.get_service(HUD)
	if !hud:
		return
	hud.add_message("Ward has been used up!")
