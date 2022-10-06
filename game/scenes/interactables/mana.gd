extends StaticBody


export var time_to_complete_seconds := 10.0
export var mana_given := 100


onready var _progress_bar: InteractionProgressBar = $InteractionProgressBar3d


func _ready():
	_progress_bar.max_value = time_to_complete_seconds


func _on_InteractionHelper_interaction_completed(_helperref, obj):
	var char_mgr: CharacterMgr = ServiceMgr.get_service(CharacterMgr)
	if !char_mgr:
		return
	var witch = char_mgr.get_witch()
	if !witch or !witch.is_selected():
		return
	witch.set_mana(mana_given)


