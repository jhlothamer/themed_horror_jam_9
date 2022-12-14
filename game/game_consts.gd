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
	PROJECTILES = 1 << 7,
}

enum PhysLayerBitIndex {
	DEFAULT = 0,
	INTERACTABLE = 1,
	INTERACTOR = 2,
	SELECTABLE = 3,
	CHARACTER = 4,
	ENEMY = 5,
	DESTRUCTABLE = 6,
	PROJECTILES = 7,
}


enum EnemySpawnDirection {
	UNKNOWN,
	NORTH,
	SOUTH,
	WEST,
	EAST,
}

enum EnemyAgressionLevel {
	UNKNOWN,
	LOW,
	MEDIUM,
	HIGH,
}


const SCENE_MOVE_TO_INDICATOR = preload("res://scenes/ui/components/move_to_indicator.tscn")

const RESOURCE_MANA = "mana"
const RESOURCE_WOOD = "wood"

const INTERACTABLE_TYPE_MANA_POOL = "mana"
const INTERACTABLE_TYPE_CRYSTAL_BALL = "crystal_ball"


const SERVICE_NAME_RETREAT_AREA_MGR = "RetreatAreaMgr"
const SERVICE_NAME_WANDER_AREA_MGR = "WanderAreaMgr"


const PLAY_AREA_BOUNDS = Rect2(Vector2.ONE*-10, Vector2.ONE*10*2)
const CHARACTER_MOVE_BOUNDS = Rect2(Vector2.ONE*-9.5, Vector2.ONE*9.5*2)

const INCLUDE_TUTORIAL = "include_tutorial"
