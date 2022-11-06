extends Spatial


export (String, FILE) var how_to_play_text_file := "res://assets/data/how_to_play.txt"


onready var _caudlron = $Cauldron
onready var _cauldron_sound = $Cauldron/StartInteractionSound
onready var _tutorial_chk: CheckButton = $MarginContainer/VBoxContainer/HBoxContainer/TutorialChckBtn
onready var _tutorial_chk_sound = $MarginContainer/VBoxContainer/HBoxContainer/TutorialChckBtn/ClickSound


func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	_caudlron._change_fire_state(true)
	_cauldron_sound.play()


func _on_PlayBtn_pressed():
	Globals.set(GameConsts.INCLUDE_TUTORIAL, _tutorial_chk.pressed)
	GameSoundTrackMgr.stop_current_track()
	_caudlron._change_fire_state(false)
	_cauldron_sound.stop()


func _on_TutorialChckBtn_toggled(_button_pressed):
	_tutorial_chk_sound.play()
