class_name TransitionButton
extends Button

signal about_to_transition()


export (String, FILE, "*.tscn,*.scn,*.res") var scene_to_load := ""
export var transition_speed_seconds := -1.0
export var fade_sound := false
export var grab_focus_on_start := false
export var alt_click_sound: NodePath

onready var _alt_click_sound:AudioStreamPlayer = get_node_or_null(alt_click_sound)
onready var _click_sound:AudioStreamPlayer = $ClickSound

func _ready():
	if grab_focus_on_start and focus_mode != FOCUS_NONE:
		grab_focus()


func _on_Button_pressed():
	if scene_to_load == null || scene_to_load == "":
		printerr("TransitionButton: no scene to load.")
		return
	
	if !_can_transition():
		return
	
	if _alt_click_sound:
		_alt_click_sound.play()
		yield(_alt_click_sound, "finished")
	else:
		_click_sound.play()
		yield(_click_sound, "finished")
	
	emit_signal("about_to_transition")
	
	TransitionMgr.transition_to(scene_to_load, transition_speed_seconds, fade_sound)


# override this to control if button will complete transition
# or do something before the transition happens
func _can_transition() -> bool:
	return true
