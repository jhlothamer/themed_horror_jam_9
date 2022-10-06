class_name CharacterMgr
extends Node


signal game_over()


var _characters := []


func _enter_tree():
	ServiceMgr.register_service(get_script(), self)


func _ready():
	SignalMgr.register_publisher(self, "game_over")


func register_character(character: Spatial) -> void:
	_characters.append(character)


func remove_character(character: Spatial) -> void:
	_characters.erase(character)
	if _characters.empty():
		yield(character, "character_death_completed")
		emit_signal("game_over")


func get_closest_character(global_pos: Vector3) -> Spatial:
	var closest_char: Spatial
	var min_distance := INF
	
	for i in _characters:
		var c: Spatial = i
		var d_sq := global_pos.distance_squared_to(c.global_transform.origin)
		if d_sq < min_distance:
			min_distance = d_sq
			closest_char = c
	
	return closest_char


func get_witch():
	for i in _characters:
		if i.name == "Witch":
			return i
	return null
