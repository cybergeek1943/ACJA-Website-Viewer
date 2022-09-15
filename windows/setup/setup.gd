extends Control


func indicator(message: String, color: Color):
	$indicator.add_color_override('font_color', color)
	$indicator.text = message


# main:
func _on_AnimationPlayer_animation_finished(anim_name):
	$text_entry_1.grab_focus()

func _on_cancel_pressed():
	get_tree().change_scene('res://windows/setup/welcome.tscn')

func _on_welcome_next_pressed():
	get_tree().change_scene('res://windows/setup/name_email.tscn')

func _on_name_email_next_pressed():
	var te1 = $text_entry_1.text
	var te2 = $text_entry_2.text
	if len(te1.replace(' ', '')) < 4 or not ' ' in te1:
		indicator('Name must include both first and last name', Color(1, 0, 0, 1))
		$text_entry_1.grab_focus()
	elif len(te2) < 5 or ' ' in te2 or not '@' in te2 or not '.' in te2:
		indicator('Email looks to be invalid', Color(1, 0, 0, 1))
		$text_entry_2.grab_focus()
	else:
		Global.user_data['acc']['name'] = Global.strip(te1.capitalize().lstrip(' '), """!"#$%&'()*+,-./:;<=>?@[\n]^_`{|}~""")
		Global.user_data['acc']['email'] = te2
		get_tree().change_scene('res://windows/setup/password.tscn')

func _on_password_next_pressed():
	var te1 = $text_entry_1.text
	var te2 = $text_entry_2.text
	if ' ' in te1:
		indicator('Password can not have any spaces', Color(1, 0, 0, 1))
	elif len(te1) < 6 or len(te2) < 6:
		indicator('Password must have (6) or more characters', Color(1, 0, 0, 1))
	elif te1 != te2:
		indicator('Passwords must match', Color(1, 0, 0, 1))
	else:
		Global.user_data['acc']['password'] = te2
		get_tree().change_scene('res://windows/setup/question_answer.tscn')

func _on_question_answer_next_pressed():
	var te1 = $text_entry_1.text
	var te2 = $text_entry_2.text
	if len(te1.split(' ')) < 2:
		indicator('Question must have (2) or more words', Color(1, 0, 0, 1))
		$text_entry_1.grab_focus()
	elif ' ' in te2 or te2 == '':
		indicator('Answer must be (1) word only and connot have spaces', Color(1, 0, 0, 1))
		$text_entry_2.grab_focus()
	else:
		Global.user_data['acc']['question'] = Global.strip(te1, """!"#$%&'()*+,-./:;<=>?@[\n]^_`{|}~""") + '?'
		Global.user_data['acc']['answer'] = Global.strip(te2.to_lower(), """ !"#$%&'()*+,-./:;<=>?@[\n]^_`{|}~""")
		Global.user_data['acc']['exists'] = true
		get_tree().change_scene('res://windows/setup/successful.tscn')

func _on_successful_next_pressed():
	Global.save_changes()
	get_tree().change_scene('res://windows/base.tscn')


## Backup:
func _on_FileDialog_file_selected(path):
	Global.restore_account_from_file(path)
	var worked = Global.restore_account_from_file(path)
	if worked:
		get_tree().change_scene('res://windows/setup/successful_restore.tscn')
	else:
		$file_corrupted.popup_centered()


func _on_restore_backup_pressed():
	$FileDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	$FileDialog.current_file = 'acja_web_viewer_account_data.save'
	$FileDialog.window_title = 'Import Account Data'
	$FileDialog.popup_centered()


func _on_file_corrupted_confirmed():
	_on_restore_backup_pressed()
