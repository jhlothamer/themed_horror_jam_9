class_name CharacterBaseState
extends State

const BBDATA_TARGET_INTERACTION_HELPER = "interaction_helper"

var character: Character

func init(_state_machine, _host) -> void:
	.init(_state_machine, _host)
	character = _host


func _add_hud_message(msg: String) -> void:
	var hud: HUD = ServiceMgr.get_service(HUD)
	if !hud:
		return
	hud.add_message(msg)
