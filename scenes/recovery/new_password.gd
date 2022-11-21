extends Control

func _ready():
	indicator('Security code successful', Color(0, 1, 0))
	$text_entry_1.grab_focus()

func indicator(message: String, color: Color = Color(1, 0, 0)):
	$backround/indicator.add_color_override("font_color", color)
	$backround/indicator.text = message
	yield(get_tree().create_timer(2), "timeout")
	$backround/indicator.text = ''

func _on_done_pressed():
	var te1 = $text_entry_1.text
	var te2 = $text_entry_2.text
	if " " in te1:
		indicator("Password can not have any spaces")
	elif len(te1) < 6 or len(te2) < 6:
		indicator("Password must have (6) or more characters")
	elif te1 != te2:
		indicator("Passwords must match")
	else:
		Global.user_data["acc"]["password"] = te2
		Global.change_scene(Global.get_previous_scene())


func _on_cancel_pressed():
	Global.change_scene(Global.get_previous_scene())
