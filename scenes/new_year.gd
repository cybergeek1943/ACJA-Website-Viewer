extends Control

func indicator(message: String, color: Color = Color(1, 0, 0)):
	$pages/indicator.add_color_override("font_color", color)
	$pages/indicator.text = message
	yield(get_tree().create_timer(2), "timeout")
	$pages/indicator.text = ''


var action: String = 'renew'
func _on_renew_pressed():
	$backround/title.text = 'Verification Needed'
	$pages/AnimationPlayer.play("next_page")
	$back/AnimationPlayer.play("show")
	$pages/password/password.grab_focus()
	$pages/continue.text = 'Renew'
	$pages/password/label.bbcode_text = '[center]Enter the current password to renew the existing account.[/center]'
	action = 'renew'

func _on_new_pressed():
	$backround/title.text = 'Verification Needed'
	$pages/AnimationPlayer.play("next_page")
	$back/AnimationPlayer.play("show")
	$pages/password/password.grab_focus()
	$pages/continue.text = 'Continue'
	$pages/password/label.bbcode_text = '[center]Enter the current password to setup a new account.[/center]'
	action = 'new'

func _on_continue_pressed():
	if Global.is_password($pages/password/password.text):
		if action == 'renew':
			Global.renew_year()
			Global.change_scene("res://scenes/base.tscn")
		elif action == 'new':
			Global.change_scene("res://scenes/setup/name_email.tscn", true)
	else:
		$pages/password/password.clear()
		indicator('Password is incorrect')

func _on_back_pressed():
	$backround/title.text = "It's a new year!"
	$pages/AnimationPlayer.play_backwards("next_page")
	$back/AnimationPlayer.play_backwards("show")
	$pages/password/password.clear()


func _on_forgot_password_pressed():
	Global.change_scene("res://scenes/recovery/recover_password.tscn", true)


func _on_hide_password_pressed():
	if $pages/password/password.secret:
		$pages/password/password.secret = false
	else:
		$pages/password/password.secret = true
