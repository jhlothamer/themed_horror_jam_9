extends CharacterBaseState


func enter() -> void:
	
	var character_mgr: CharacterMgr = ServiceMgr.get_service(CharacterMgr)
	if character_mgr:
		character_mgr.remove_character(character)
	
	character.queue_free()
