class_name GameConsts
extends Object


enum PhysLayer {
	DEFAULT = 1,
	INTERACTABLE = 1 << 1,
	INTERACTOR = 1 << 2,
	SELECTABLE = 1 << 3,
	CHARACTER = 1 << 4,
	ENEMY = 1 << 5,
}


const SCENE_MOVE_TO_INDICATOR = preload("res://scenes/ui/components/move_to_indicator.tscn")

