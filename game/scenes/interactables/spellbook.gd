extends StaticBody


signal spell_activated()
signal spell_deactivated()


onready var _spellbook_active_indicator = $SpellbookRunes


func _ready():
	SignalMgr.register_publisher(self, "spell_activated")
	SignalMgr.register_publisher(self, "spell_deactivated")


func _on_InteractionHelper_interaction_started(_interactor):
	emit_signal("spell_activated")
	_spellbook_active_indicator.visible = true


func _on_InteractionHelper_interaction_interrupted(_interactor):
	emit_signal("spell_deactivated")
	_spellbook_active_indicator.visible = false
