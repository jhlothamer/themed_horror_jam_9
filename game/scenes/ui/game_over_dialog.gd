extends Control

onready var _retry_btn: Button = $VBoxContainer/RetryBtn
onready var _game_over_sound: AudioStreamPlayer = $GameOverSound


func _ready():
	visible = false
	SignalMgr.register_subscriber(self, "game_over")



func _on_game_over():
		visible = true
		get_tree().paused = true
		_retry_btn.grab_focus()
		_game_over_sound.play()
	
