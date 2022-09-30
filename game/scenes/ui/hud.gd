extends CanvasLayer

signal no_selectable_clicked()
signal no_interactable_clicked(position)


func _ready():
	SignalMgr.register_publisher(self, "no_selectable_clicked")
	SignalMgr.register_publisher(self, "no_interactable_clicked")
	

func _input(event):
	if event.is_echo() or !event is InputEventMouseButton or !event.is_pressed():
		return
	var em := event as InputEventMouseButton
	if em.button_index == BUTTON_LEFT:
		if Vector3.INF == _test_world_mouse_click_collision(em.position, GameConsts.PhysLayer.SELECTABLE, 0):
			emit_signal("no_selectable_clicked")
	elif em.button_index == BUTTON_RIGHT:
		var position = _test_world_mouse_click_collision(em.position, GameConsts.PhysLayer.DEFAULT, GameConsts.PhysLayer.INTERACTABLE | GameConsts.PhysLayer.SELECTABLE)
		if position != Vector3.INF:
			emit_signal("no_interactable_clicked", position)


func _test_world_mouse_click_collision(mouse_position, collision_mask: int, ignore_mask: int) -> Vector3:
	var camera = get_viewport().get_camera()
	var from = camera.project_ray_origin(mouse_position)
	var to = camera.project_position(mouse_position, camera.far * 2.0)
	var space_state = camera.get_world().direct_space_state
	
	var result = space_state.intersect_ray(from, to, [], collision_mask, true, true)
	
	if !result:
		return Vector3.INF
	
	if result["collider"] is CollisionObject and ignore_mask != 0:
		var co: CollisionObject = result["collider"]
		if co.collision_layer & ignore_mask != 0:
			return Vector3.INF
		
	return result["position"]



