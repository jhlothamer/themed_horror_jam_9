extends Character


func _ready():
	SignalMgr.register_subscriber(self, "spell_activated")
	SignalMgr.register_subscriber(self, "spell_deactivated")


func _on_spell_activated():
	can_shoot = true
	if !allowed_interactable_types.has(GameConsts.INTERACTABLE_TYPE_MANA_POOL):
		allowed_interactable_types.append(GameConsts.INTERACTABLE_TYPE_MANA_POOL)


func _on_spell_deactivated():
	can_shoot = false
	allowed_interactable_types.erase(GameConsts.INTERACTABLE_TYPE_MANA_POOL)
	var _discard = resources.erase(GameConsts.RESOURCE_MANA)
