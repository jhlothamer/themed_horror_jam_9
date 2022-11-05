extends Control


onready var _label:RichTextLabel = $RichTextLabel


func _ready():
	
	#var msg = InputPromptUtil.replace_input_prompts("[%%prompt:key:0:previous_camera%%] [%%prompt:key:0:next_camera%%] or [%%prompt:key:1:previous_camera%%] [%%prompt:key:1:next_camera%%]", true)
	#var msg = InputPromptUtil.replace_input_prompts("[%%prompt:key:1:previous_camera%%] [%%prompt:key:1:next_camera%%]", true)
	var msg = InputPromptUtil.replace_input_prompts("[%%prompt:key:1:previous_camera%%]", true)
	_label.bbcode_text = "[center]%s[/center]" % msg

