extends StaticBody


signal spell_activated()
signal spell_deactivated()


onready var _spellbook_active_indicator = $SpellbookRunes


var _instructions_shown := false


func _ready():
	SignalMgr.register_publisher(self, "spell_activated")
	SignalMgr.register_publisher(self, "spell_deactivated")


func _on_InteractionHelper_interaction_started(_interactor):
	emit_signal("spell_activated")
	_spellbook_active_indicator.visible = true
	if _instructions_shown:
		return
	_instructions_shown = true
	var hud: HUD = ServiceMgr.get_service(HUD)
	hud.add_message("Spell active.  Minions can now shoot magic missiles!  They also work a little faster.")


func _on_InteractionHelper_interaction_interrupted(_interactor):
	emit_signal("spell_deactivated")
	_spellbook_active_indicator.visible = false
	var hud: HUD = ServiceMgr.get_service(HUD)
	hud.add_message("Spell deactivated.  Minions can no longer shoot magic missiles! Their speed is also reduced to normal.")
