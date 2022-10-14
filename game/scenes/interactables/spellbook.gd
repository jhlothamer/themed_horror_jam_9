extends StaticBody


signal spell_activated()
signal spell_deactivated()


func _ready():
	SignalMgr.register_publisher(self, "spell_activated")
	SignalMgr.register_publisher(self, "spell_deactivated")


func _on_InteractionHelper_interaction_started(_interactor):
	emit_signal("spell_activated")


func _on_InteractionHelper_interaction_interrupted(_interactor):
	emit_signal("spell_deactivated")
