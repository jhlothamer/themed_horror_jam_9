class_name HUD
extends CanvasLayer

const SKIP_TUTORIAL_LABEL_TEXT = "Press %%prompt:key:0:skip_tutorial%% to skip tutorial"


signal no_selectable_clicked()
signal no_interactable_clicked(position)


export var message_show_time := 10.0
export var message_fade_out_time := 1.0


onready var _message_container: Control = $MarginContainer/MessagesContainer
onready var _message_label: RichTextLabel = $MarginContainer/MessagesContainer/RichTextLabel
onready var _skip_tutoral_container: MarginContainer = $SkipTutorialMarginContainer
onready var _skip_tutoral_label: RichTextLabel = $SkipTutorialMarginContainer/SkipTutorialLabel

func _enter_tree():
	ServiceMgr.register_service(get_script(), self)


func _ready():
	SignalMgr.register_publisher(self, "no_selectable_clicked")
	SignalMgr.register_publisher(self, "no_interactable_clicked")
	SignalMgr.register_subscriber(self, "tutorial_started")
	SignalMgr.register_subscriber(self, "tutorial_completed")
	
	_message_label.visible = false
	_skip_tutoral_label.bbcode_text = InputPromptUtil.replace_input_prompts(SKIP_TUTORIAL_LABEL_TEXT, InputPromptUtil.PromptImageSize.MEDIUM)
	_skip_tutoral_container.visible = false


func _input(event):
	if event.is_echo() or !event.is_pressed() or !event is InputEventMouseButton:
		return
	
	var em := event as InputEventMouseButton
	if em.button_index == BUTTON_LEFT:
		if Vector3.INF == _test_world_mouse_click_collision(em.position, GameConsts.PhysLayerMask.SELECTABLE, 0, false):
			emit_signal("no_selectable_clicked")
	elif em.button_index == BUTTON_RIGHT:
		# check if there's an area at position first
		var position = _test_world_mouse_click_collision(em.position, GameConsts.PhysLayerMask.DEFAULT | GameConsts.PhysLayerMask.INTERACTABLE, GameConsts.PhysLayerMask.INTERACTABLE | GameConsts.PhysLayerMask.SELECTABLE, false)
		if position == Vector3.INF:
			# no area - now check for bodies
			position = _test_world_mouse_click_collision(em.position, GameConsts.PhysLayerMask.DEFAULT | GameConsts.PhysLayerMask.INTERACTABLE, GameConsts.PhysLayerMask.INTERACTABLE | GameConsts.PhysLayerMask.SELECTABLE)
			if position != Vector3.INF:
				emit_signal("no_interactable_clicked", position)


func _test_world_mouse_click_collision(mouse_position, collision_mask: int, ignore_mask: int, include_bodies: bool = true) -> Vector3:
	var camera = get_viewport().get_camera()
	if !camera is Camera:
		return Vector3.ZERO
	var from = camera.project_ray_origin(mouse_position)
	var to = camera.project_position(mouse_position, camera.far * 2.0)
	var space_state = camera.get_world().direct_space_state
	
	var result = space_state.intersect_ray(from, to, [], collision_mask, include_bodies, true)
	
	if !result:
		return Vector3.INF
	
	if result["collider"] is CollisionObject and ignore_mask != 0:
		var co: CollisionObject = result["collider"]
		if co.collision_layer & ignore_mask != 0:
			return Vector3.INF
		
	return result["position"]


func add_message(msg: String, sticky: bool = false) -> void:
	var label = _message_label.duplicate()
	label.bbcode_text = "[center]%s[/center]" % msg
	label.modulate = Color.transparent
	label.visible = true
	_message_container.add_child(label)
	var tween := get_tree().create_tween()
	var _discard = tween.tween_property(label, "modulate:a", 1.0, message_fade_out_time)
	tween.play()
	yield(tween, "finished")
	if sticky:
		return
	yield(get_tree().create_timer(message_show_time), "timeout")
	tween = get_tree().create_tween()
	_discard = tween.tween_property(label, "modulate:a", 0.0, message_fade_out_time)
	tween.play()
	yield(tween, "finished")
	label.queue_free()


func remove_message(msg: String) -> void:
	var message_label: RichTextLabel
	var bbcode_text = "[center]%s[/center]" % msg
	for i in _message_container.get_children():
		var label: RichTextLabel = i
		if label.bbcode_text == bbcode_text:
			message_label = label
			break
	if !message_label:
		return
	var tween = get_tree().create_tween()
	var _discard = tween.tween_property(message_label, "modulate:a", 0.0, message_fade_out_time)
	tween.play()
	yield(tween, "finished")
	message_label.queue_free()


func _on_tutorial_started():
	_skip_tutoral_container.visible = true


func _on_tutorial_completed():
	_skip_tutoral_container.visible = false
