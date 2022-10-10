class_name GameConsts
extends Object


enum PhysLayerMask {
	DEFAULT = 1 << 0,
	INTERACTABLE = 1 << 1,
	INTERACTOR = 1 << 2,
	SELECTABLE = 1 << 3,
	CHARACTER = 1 << 4,
	ENEMY = 1 << 5,
	DESTRUCTABLE = 1 << 6,
}

enum PhysLayerBitIndex {
	DEFAULT = 0,
	INTERACTABLE = 1,
	INTERACTOR = 2,
	SELECTABLE = 3,
	CHARACTER = 4,
	ENEMY = 5,
	DESTRUCTABLE = 6,
}


const SCENE_MOVE_TO_INDICATOR = preload("res://scenes/ui/components/move_to_indicator.tscn")

