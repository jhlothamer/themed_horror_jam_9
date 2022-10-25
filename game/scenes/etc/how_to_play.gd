extends Control


export (String, FILE) var how_to_play_text_file := "res://assets/data/how_to_play.txt"


onready var _how_to_play_lbl: RichTextLabel = $MarginContainer/VBoxContainer/HowToPlayRichTextLbl


func _ready():
	var how_to_play_text = FileUtil.load_text(how_to_play_text_file)
	_how_to_play_lbl.bbcode_text = InputPromptUtil.replace_input_prompts(how_to_play_text)


func _on_PlayBtn_pressed():
	GameSoundTrackMgr.stop_current_track()
