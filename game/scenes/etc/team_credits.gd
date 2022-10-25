extends RichTextLabel

const TEAM_CREDITS_BB_CODE_FILE_PATH := "res://assets/data/team_credits.txt"


func _ready():
	if !FileUtil.exists(TEAM_CREDITS_BB_CODE_FILE_PATH):
		return
	bbcode_text = FileUtil.load_text(TEAM_CREDITS_BB_CODE_FILE_PATH)


func _on_Team_meta_clicked(meta):
	OS.shell_open(str(meta))
