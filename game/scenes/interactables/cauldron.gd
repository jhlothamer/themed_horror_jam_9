extends StaticBody

signal game_won_sequence_began()
signal game_won()


export var time_to_complete_minutes := 20.0
export var fire_change_time_seconds := 1.0


onready var _progress_bar: InteractionProgressBar = $InteractionProgressBar3d
onready var _fire_shader:ShaderMaterial = $FireMeshInstance.get("material/0")
onready var _tween: Tween = $Tween
onready var _bubble_particles:Particles = $BubbleParticles
onready var _potion_mesh_instance = $cauldron_matrix/Circle


func _ready():
	SignalMgr.register_publisher(self, "game_won")
	_progress_bar.max_value = time_to_complete_minutes * 60.0
	_change_fire_state(false)


func _change_fire_state(on: bool) -> void:
	if _bubble_particles.emitting == on:
		return
	var start = 0.4 if !on else 1.0
	var end = 0.4 if on else 1.0
	if _tween.is_active():
		yield(_tween, "tween_all_completed")
	if !_tween.interpolate_property(_fire_shader, "shader_param/fire_aperture", start, end, fire_change_time_seconds):
		printerr("%n: Unable to interpolate shader parameter" % name)
	if !_tween.start():
		printerr("%n: Unable to start tween" % name)
	_bubble_particles.emitting = on


func _on_InteractionHelper_interaction_completed(_helperref, _obj):
	emit_signal("game_won")


func _on_InteractionHelper_interaction_started(_interactor):
	_change_fire_state(true)


func _on_InteractionHelper_interaction_interrupted(_interactor):
	_change_fire_state(false)


func hide_potion() -> void:
	_potion_mesh_instance.visible = false



func _on_InteractionHelper_interaction_completion_began():
	emit_signal("game_won_sequence_began")
	_bubble_particles.emitting = false
