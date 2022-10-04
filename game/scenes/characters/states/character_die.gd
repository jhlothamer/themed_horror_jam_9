extends CharacterBaseState


func enter() -> void:
	
	var character_mgr: CharacterMgr = ServiceMgr.get_service(CharacterMgr)
	if character_mgr:
		character_mgr.remove_character(character)
	
	if character.death_sound:
		character.death_sound.play()
		yield(character.death_sound, "finished")
	
	character.emit_signal("character_death_completed")
	character.queue_free()
