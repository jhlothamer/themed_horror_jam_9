class_name TutorialMgr
extends Node

const WAIT_FOR_DESTRCUTABLE_INTERACTION_OBJECT_NAME = "Destructable"

signal tutorial_started()
signal tutorial_completed()
signal _tutorial_skipped()
signal _interaction_completed()
signal _interaction_started()
signal _ward_activated()

export var cauldron: NodePath
export var woodpile: NodePath
export var crystal_ball: NodePath
export var mana_pool: NodePath
export var spellbook: NodePath
export var pause_between_instructions := 6.0

var is_skipped := false

onready var _cauldron = get_node(cauldron)
onready var _woodpile = get_node(woodpile)
onready var _crystal_ball = get_node(crystal_ball)
onready var _mana_pool = get_node(mana_pool)
onready var _spellbook = get_node(spellbook)


var _waiting_interaction_on_object_name := ""
var _hud: HUD

func _enter_tree():
	ServiceMgr.register_service(get_script(), self)


func _ready():
	SignalMgr.register_subscriber(self, "interaction_completed")
	SignalMgr.register_subscriber(self, "interaction_started_more_info")
	SignalMgr.register_subscriber(self, "ward_activated")
	SignalMgr.register_publisher(self, "tutorial_started")
	SignalMgr.register_publisher(self, "tutorial_completed")
	_hud = ServiceMgr.get_service(HUD)
	call_deferred("_run_tutorial")

func _is_tutorial_included() -> bool:
	var value = Globals.get(GameConsts.INCLUDE_TUTORIAL)
	if value == null:
		return true
	return value

func _run_tutorial() -> void:
	if !_is_tutorial_included():
		emit_signal("tutorial_completed")
		return
	
	emit_signal("tutorial_started")
	
	yield(_wait(pause_between_instructions / 2.0), "completed")
	if is_skipped:
		return

	# player start interaction with cauldron
	yield(_wait_for_interaction(_cauldron, "_interaction_started", "Left click on a minion and then right click on the cauldron to have them stir it."), "completed")
	if is_skipped:
		return
	_add_hud_message("Great!  You just learned that left clicking selects a character, right clicking commands them to do something.")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return
	_add_hud_message("Note that the witch can stir the cauldron too.")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return

	# player completes interaction with woodpile
	yield(_wait_for_interaction(_woodpile, "_interaction_completed", "Select a minion and right click on the woodpile to have them collect some wood."), "completed")
	if is_skipped:
		return
	_add_hud_message("Now the minion can make repairs.")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return

	# player completes interaction with mana pool
	yield(_wait_for_interaction(_mana_pool, "_interaction_completed", "Select the witch and right click on the mana pool."), "completed")
	if is_skipped:
		return
	_add_hud_message("Now the witch has mana to cast spells with.")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return
	_add_hud_message("She can cast magic missiles at zombies and cast a ward spell at the crystal ball.")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return

	# player start interaction with crystal ball
	var ward_mgr:WardMgr = ServiceMgr.get_service(WardMgr)
	if ward_mgr:
		ward_mgr.disabled = true
	yield(_wait_for_interaction(_crystal_ball, "_interaction_started", "Select the witch again if necessary and right click on the crystal ball table."), "completed")
	if is_skipped:
		return
	_add_hud_message("Change crystal ball view with %%prompt:key:0:previous_camera%% / %%prompt:key:0:next_camera%% or %%prompt:key:1:previous_camera%% / %%prompt:key:1:next_camera%%")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return
	_add_hud_message("Now the witch can see what's coming.  Look out for the incoming zombie!")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return

	# send zombie (medium agression)
	var enemy_spawn_mgr: EnemySpawnMgr = ServiceMgr.get_service(EnemySpawnMgr)
	if enemy_spawn_mgr:
		enemy_spawn_mgr.spawn_enemy(GameConsts.EnemyAgressionLevel.MEDIUM)

	# player fixes destructable (or completes interaction)
	yield(_wait_for_interaction(null, "_interaction_completed", "Select the minion that gathered wood and right click on the broken door or window to repair it."), "completed")
	if is_skipped:
		return
	_add_hud_message("You'll need to have minions restock on wood to make more repairs.")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return
	
	# player place ward
	if ward_mgr:
		ward_mgr.disabled = false
	yield(_wait_for_interaction(null, "_ward_activated", "Have the witch cast a ward from the crystal ball by pressing %%prompt:key:0:place_ward%%."), "completed")
	if is_skipped:
		return
	_add_hud_message("Wards will cause 5 zombies to retreat or die and then deactivate.")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return
	_add_hud_message("The spell runes on the crystal ball will disappear letting you know you can cast another ward.")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return
	_add_hud_message("Only one ward can be cast at a time.")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return

	# player interacts with spellbook
	yield(_wait_for_interaction(_spellbook, "_interaction_started", "Select the witch again if necessary and right click on the spellbook."), "completed")
	if is_skipped:
		_add_hud_message("Good luck!")
		emit_signal("tutorial_completed")
		return
	_add_hud_message("While spell is active, minions can gather mana from mana pool and cast magic missiles.  They also work a little faster.")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return
	
	# end tutorial
	_add_hud_message("This concludes the tutorial.")
	_add_hud_message("Now the game begins!")
	yield(_wait(pause_between_instructions), "completed")
	if is_skipped:
		return
	_add_hud_message("Good luck!")
	emit_signal("tutorial_completed")


func _wait_for_interaction(object: Node, interaction_signal: String, hud_msg: String):
	if !object:
		_waiting_interaction_on_object_name = WAIT_FOR_DESTRCUTABLE_INTERACTION_OBJECT_NAME
	else:
		_waiting_interaction_on_object_name = object.name
	_add_hud_message(hud_msg, true)
	var yu := YieldUtil.new()
	yu.add(self, interaction_signal)
	yu.add(self, "_tutorial_skipped")
	yield(yu, "completed")
	if _hud:
		_hud.remove_message(InputPromptUtil.replace_input_prompts(hud_msg, InputPromptUtil.PromptImageSize.MEDIUM))
	if is_skipped:
		_handle_skip()


func _wait(wait: float):
	var timer := get_tree().create_timer(wait)
	var yu := YieldUtil.new()
	yu.add(timer, "timeout")
	yu.add(self, "_tutorial_skipped")
	yield(yu, "completed")
	if is_skipped:
		_handle_skip()
	

func _add_hud_message(msg: String, sticky: bool = false) -> void:
	if !_hud:
		return
	_hud.add_message(InputPromptUtil.replace_input_prompts(msg, InputPromptUtil.PromptImageSize.MEDIUM), sticky)


func _on_interaction_completed(_helperref, obj, _interactor):
	if obj.name == _waiting_interaction_on_object_name:
		emit_signal("_interaction_completed")
		return
	if _waiting_interaction_on_object_name == WAIT_FOR_DESTRCUTABLE_INTERACTION_OBJECT_NAME and \
		obj is Destructable:
		emit_signal("_interaction_completed")


func _on_interaction_started_more_info(_helperref, obj, _interactor):
	if obj.name == _waiting_interaction_on_object_name:
		emit_signal("_interaction_started")
		return
	if _waiting_interaction_on_object_name == WAIT_FOR_DESTRCUTABLE_INTERACTION_OBJECT_NAME and \
		obj is Destructable:
		emit_signal("_interaction_started")


func _on_ward_activated():
	emit_signal("_ward_activated")

func _input(event):
	if event.is_action_pressed("skip_tutorial"):
		is_skipped = true
		emit_signal("_tutorial_skipped")

func _handle_skip() -> void:
	var ward_mgr:WardMgr = ServiceMgr.get_service(WardMgr)
	if ward_mgr:
		ward_mgr.disabled = false
	_add_hud_message("Tutorial skipped.")
	_add_hud_message("Good luck!")
	emit_signal("tutorial_completed")
